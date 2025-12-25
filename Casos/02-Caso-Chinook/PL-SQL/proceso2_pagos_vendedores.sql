/*
PROCESO 2: CALCULO Y ALMACENAMIENTO DE PAGOS A VENDEDORES

DESCRIPCION:
Este proceso calcula y almacena los pagos mensuales de vendedores considerando:
- Sueldo base
- Comision especial segun rango de sueldo
- Colacion segun edad del vendedor
- Movilizacion (5% del sueldo base)
- Descuentos de prevision (13%) y salud (7%)

REQUISITOS:
- Solo vendedores de comunas SANTIAGO y NUNOA
- Solo vendedores con ventas en el periodo a procesar
- Almacenar resultados en tabla pago_vendedor

COMPONENTES:
1. Package pkg_calculo_pagos
2. Funcion fn_pct_aum_colacion
3. Procedimiento sp_procesar_pagos_vendedores
*/

-- PASO 0: CORREGIR RANGOS DE SUELDOS

PROMPT Corrigiendo rangos de sueldos en conflicto... 

-- Los rangos originales con error, causando error TOO_MANY_ROWS
-- Rango 2: 300,001 - 700,000
-- Rango 3: 500,001 - 900,000  <- error con rango 2

-- entonces q solucion?: Ajustar para que no haya error
UPDATE rangos_sueldos SET sueldo_max = 500000 WHERE cod_rango = 2;
UPDATE rangos_sueldos SET sueldo_min = 500001 WHERE cod_rango = 3;

-- Verificamo los rangos corregidos
SELECT 
    cod_rango,
    TO_CHAR(sueldo_min, '999G999G999') AS sueldo_min,
    TO_CHAR(sueldo_max, '999G999G999') AS sueldo_max,
    porc_honorario
FROM rangos_sueldos
ORDER BY sueldo_min;

COMMIT;

PROMPT Rangos estan bien arreglados

-- COMPONENTE 1: PACKAGE SPECIFICATION

CREATE OR REPLACE PACKAGE pkg_calculo_pagos AS
    /*
    Package para calculos de pagos de vendedores
    Contiene variables publicas, funcion para calcular porcentaje por rango
    y procedimiento para gestionar errores
    */
    
    -- Variables publicas (osea q se pueden usar en consultas)
    g_periodo_mes NUMBER(2);           -- Mes a procesar
    g_periodo_anno NUMBER(4);          -- Ano a procesar
    g_porc_prevision NUMBER(4,2) := 13;   -- Porcentaje de prevision
    g_porc_salud NUMBER(4,2) := 7;        -- Porcentaje de salud
    
    -- Funcion publica para obtener porcentaje por rango de sueldo
    FUNCTION fn_pct_por_rango(p_sueldo_base NUMBER) RETURN NUMBER;
    
    -- Procedimiento publico para registrar errores
    PROCEDURE sp_registrar_error(
        p_rutina VARCHAR2,
        p_mensaje VARCHAR2
    );
    
END pkg_calculo_pagos;
/

-- COMPONENTE 1: PACKAGE BODY

CREATE OR REPLACE PACKAGE BODY pkg_calculo_pagos AS

    -- FUNCION: fn_pct_por_rango
    -- Obtiene el porcentaje de honorario segun rango de sueldo
    FUNCTION fn_pct_por_rango(p_sueldo_base NUMBER) RETURN NUMBER IS
        v_porc_honorario NUMBER(4,2);
    BEGIN
        -- Buscar el porcentaje segun el rango del sueldo
        SELECT porc_honorario
        INTO v_porc_honorario
        FROM rangos_sueldos
        WHERE p_sueldo_base BETWEEN sueldo_min AND sueldo_max;
        
        RETURN v_porc_honorario;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Registramo el error
            sp_registrar_error(
                'pkg_calculo_pagos.fn_pct_por_rango',
                'No se encontro rango para sueldo: ' || p_sueldo_base || ' - ' || SQLERRM
            );
            RETURN 0;
            
        WHEN TOO_MANY_ROWS THEN
            -- denuevo registramo el error
            sp_registrar_error(
                'pkg_calculo_pagos.fn_pct_por_rango',
                'Multiples rangos encontrados para sueldo: ' || p_sueldo_base || ' - ' || SQLERRM
            );
            RETURN 0;
            
        WHEN OTHERS THEN
            -- otra vez registramo el error
            sp_registrar_error(
                'pkg_calculo_pagos.fn_pct_por_rango',
                'Error inesperado para sueldo: ' || p_sueldo_base || ' - ' || SQLERRM
            );
            RETURN 0;
    END fn_pct_por_rango;

    -- PROCEDIMIENTO: sp_registrar_error
    -- Registramo errores en tabla error_procesos_mensuales
    -- Utiliza Native Dynamic SQL (osea q se usa sql dinamico) para insertar el error
    PROCEDURE sp_registrar_error(
        p_rutina VARCHAR2,
        p_mensaje VARCHAR2
    ) IS
        v_sql VARCHAR2(1000);
        v_correl_error NUMBER;
    BEGIN
        -- Obtenemos el siguiente correl_error de error
        SELECT seq_error.NEXTVAL INTO v_correl_error FROM DUAL;
        
        -- Construimos la sentencia SQL dinamica
        v_sql := 'INSERT INTO error_procesos_mensuales ' ||
                 '(correl_error, rutina_error, descrip_error) ' ||
                 'VALUES (:1, :2, :3)';
        
        -- Ejecutamos con Native Dynamic SQL, "alto nombre"
        EXECUTE IMMEDIATE v_sql 
        USING v_correl_error, p_rutina, SUBSTR(p_mensaje, 1, 255);
        
        -- Commit del registro de error
        COMMIT;
        
        -- Mostramos el mensaje en consola
        DBMS_OUTPUT.PUT_LINE('ERROR registrado en tabla: ' || p_rutina);
        DBMS_OUTPUT.PUT_LINE('Mensaje: ' || p_mensaje);
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Si falla el registro de error, mostramos en consola
            DBMS_OUTPUT.PUT_LINE('ERROR CRITICO al registrar error: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('Rutina original: ' || p_rutina);
            DBMS_OUTPUT.PUT_LINE('Mensaje original: ' || p_mensaje);
    END sp_registrar_error;

END pkg_calculo_pagos;
/

-- COMPONENTE 2: FUNCION ALMACENADA
-- fn_pct_aum_colacion

CREATE OR REPLACE FUNCTION fn_pct_aum_colacion(
    p_fecha_nacimiento DATE,
    p_sueldo_base NUMBER
) RETURN NUMBER IS
    /*
    Calculamos el monto de colacion del vendedor segun su edad
    donde se aplica directamente el porcentaje de la tabla rango_aumento_porc_col
    al sueldo base segun el rango de edad del vendedor
    
    PARAMETROS:
    - p_fecha_nacimiento: Fecha de nacimiento del vendedor
    - p_sueldo_base: Sueldo base del vendedor
    
    RETORNA:
    - Monto de colacion calculado
    */
    
    v_edad NUMBER;
    v_porc_aumento NUMBER(3);
    v_colacion_final NUMBER(8,2);
    
BEGIN
    -- Calculamos la edad actual del vendedor
    v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, p_fecha_nacimiento) / 12);
    
    BEGIN
        -- Obtenemos el porcentaje segun edad desde tabla rango_aumento_porc_col
        SELECT porc_aumento
        INTO v_porc_aumento
        FROM rango_aumento_porc_col
        WHERE v_edad BETWEEN edad_min AND edad_max;
        
        -- Calculamos la colacion aplicando porcentaje directamente al sueldo base
        -- CORRECCION: NO se usa el 5% del sueldo base como indica la fe de erratas
        v_colacion_final := p_sueldo_base * (v_porc_aumento / 100);
        
        RETURN ROUND(v_colacion_final);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Si no hay rango para la edad, registrar error y retornar 0
            pkg_calculo_pagos.sp_registrar_error(
                'fn_pct_aum_colacion',
                'No se encontro rango de edad para: ' || v_edad || ' anos. RUT Vendedor con fecha: ' || 
                TO_CHAR(p_fecha_nacimiento, 'DD/MM/YYYY') || ' - ' || SQLERRM
            );
            RETURN 0;
            
        WHEN TOO_MANY_ROWS THEN
            pkg_calculo_pagos.sp_registrar_error(
                'fn_pct_aum_colacion',
                'Multiples rangos encontrados para edad: ' || v_edad || ' - ' || SQLERRM
            );
            RETURN 0;
            
        WHEN OTHERS THEN
            pkg_calculo_pagos.sp_registrar_error(
                'fn_pct_aum_colacion',
                'Error inesperado al calcular colacion. Edad: ' || v_edad || ' - ' || SQLERRM
            );
            RETURN 0;
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Error en calculo de edad u otro
        pkg_calculo_pagos.sp_registrar_error(
            'fn_pct_aum_colacion',
            'Error critico en funcion. Fecha nac: ' || TO_CHAR(p_fecha_nacimiento, 'DD/MM/YYYY') || 
            ', Sueldo: ' || p_sueldo_base || ' - ' || SQLERRM
        );
        RETURN 0;
END fn_pct_aum_colacion;
/

-- COMPONENTE 3: PROCEDIMIENTO PRINCIPAL
-- sp_procesar_pagos_vendedores

CREATE OR REPLACE PROCEDURE sp_procesar_pagos_vendedores(
    p_mes NUMBER,
    p_anno NUMBER
) IS
    /*
    Procedimiento principal que calcula y almacena los pagos de vendedores
    para un mes y ano especifico.
    
    PARAMETROS:
    - p_mes: Mes a procesar (1-12)
    - p_anno: Ano a procesar (ej: 2020) "es mas chistoso que annio"
    
    PROCESO:
    1. Limpiar tabla de resultados
    2. Obtener vendedores de SANTIAGO y NUNOA con ventas en el periodo
    3. Calcular todos los componentes del pago
    4. Insertar en pago_vendedor
    */
    
    -- Variables para calculos
    v_contador NUMBER := 0;
    v_mes_anno VARCHAR2(10);
    v_sql_truncate VARCHAR2(100);
    
    -- Tipo RECORD para almacenar datos de vendedor
    TYPE t_vendedor_rec IS RECORD (
        rutvendedor    vendedor.rutvendedor%TYPE,
        nombre         vendedor.nombre%TYPE,
        sueldo_base    vendedor.sueldo_base%TYPE,
        comision       vendedor.comision%TYPE,
        fecha_nac      vendedor.fecha_nac%TYPE
    );
    
    -- Tipo VARRAY para almacenar multiples vendedores
    TYPE t_vendedores_array IS VARRAY(100) OF t_vendedor_rec;
    v_vendedores t_vendedores_array := t_vendedores_array();
    
    -- Variables para calculos de pago
    v_comision_mes NUMBER(8);
    v_colacion NUMBER(8);
    v_movilizacion NUMBER(8);
    v_prevision NUMBER(8);
    v_salud NUMBER(8);
    v_total_pagar NUMBER(8);
    v_pct_honorario NUMBER(4,2);
    
    -- Cursor para obtener vendedores que cumplen criterios
    CURSOR cur_vendedores IS
        SELECT DISTINCT 
            v.rutvendedor,
            v.nombre,
            v.sueldo_base,
            v.comision,
            v.fecha_nac
        FROM vendedor v
        INNER JOIN comuna c ON v.codcomuna = c.codcomuna
        INNER JOIN boleta b ON v.rutvendedor = b.rutvendedor
        WHERE UPPER(c.descripcion) IN ('SANTIAGO', 'NUNOA')
          AND EXTRACT(MONTH FROM b.fecha) = p_mes
          AND EXTRACT(YEAR FROM b.fecha) = p_anno
        ORDER BY v.rutvendedor;
    
BEGIN
    -- Inicializamo las variables publicas del package
    pkg_calculo_pagos.g_periodo_mes := p_mes;
    pkg_calculo_pagos.g_periodo_anno := p_anno;
    
    -- Creamos el formato mes_anno (MMAAAA)
    v_mes_anno := LPAD(p_mes, 2, '0') || p_anno;
    
    DBMS_OUTPUT.PUT_LINE('PROCESO DE CALCULO DE PAGOS A VENDEDORES');
    DBMS_OUTPUT.PUT_LINE('Periodo: ' || TO_CHAR(TO_DATE(p_mes || '/01/' || p_anno, 'MM/DD/YYYY'), 'MONTH YYYY'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Limpiamos la tabla de resultados usando SQL Dinamico
    v_sql_truncate := 'TRUNCATE TABLE pago_vendedor';
    EXECUTE IMMEDIATE v_sql_truncate;
    DBMS_OUTPUT.PUT_LINE('Tabla pago_vendedor limpiada correctamente');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Cargamos los vendedores que cumplen criterios
    FOR rec_vendedor IN cur_vendedores LOOP
        v_vendedores.EXTEND;
        v_vendedores(v_vendedores.COUNT).rutvendedor := rec_vendedor.rutvendedor;
        v_vendedores(v_vendedores.COUNT).nombre := rec_vendedor.nombre;
        v_vendedores(v_vendedores.COUNT).sueldo_base := rec_vendedor.sueldo_base;
        v_vendedores(v_vendedores.COUNT).comision := rec_vendedor.comision;
        v_vendedores(v_vendedores.COUNT).fecha_nac := rec_vendedor.fecha_nac;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total de vendedores a procesar: ' || v_vendedores.COUNT);
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Procesando vendedores...');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Procesar cada vendedor
    FOR i IN 1..v_vendedores.COUNT LOOP
        
        BEGIN
            -- Obtener porcentaje por rango usando funcion del package
            v_pct_honorario := pkg_calculo_pagos.fn_pct_por_rango(v_vendedores(i).sueldo_base);
            
            -- Calculamos la comision especial
            -- Comision = Sueldo Base * Comision Vendedor * PCT Honorario
            v_comision_mes := ROUND(v_vendedores(i).sueldo_base * 
                                   v_vendedores(i).comision * 
                                   v_pct_honorario);
            
            -- Calculamos la colacion mejorada usando funcion almacenada
            v_colacion := fn_pct_aum_colacion(
                v_vendedores(i).fecha_nac,
                v_vendedores(i).sueldo_base
            );
            
            -- Calculamos la movilizacion (5% del sueldo base)
            v_movilizacion := ROUND(v_vendedores(i).sueldo_base * 0.05);
            
            -- Calculamos los descuentos
            v_prevision := ROUND(v_vendedores(i).sueldo_base * 
                               pkg_calculo_pagos.g_porc_prevision / 100);
            v_salud := ROUND(v_vendedores(i).sueldo_base * 
                           pkg_calculo_pagos.g_porc_salud / 100);
            
            -- Y calculamos el total a pagar
            -- Total = Sueldo Base + Comision + Colacion + Movilizacion - Prevision - Salud
            v_total_pagar := v_vendedores(i).sueldo_base + 
                            v_comision_mes + 
                            v_colacion + 
                            v_movilizacion - 
                            v_prevision - 
                            v_salud;
            
            -- Insertar en tabla de resultados
            INSERT INTO pago_vendedor (
                mes_anno,
                rutvendedor,
                nomvendedor,
                sueldo_base,
                comision_mes,
                colacion,
                movilizacion,
                prevision,
                salud,
                total_pagar
            ) VALUES (
                v_mes_anno,
                v_vendedores(i).rutvendedor,
                v_vendedores(i).nombre,
                v_vendedores(i).sueldo_base,
                v_comision_mes,
                v_colacion,
                v_movilizacion,
                v_prevision,
                v_salud,
                v_total_pagar
            );
            
            v_contador := v_contador + 1;
            
            DBMS_OUTPUT.PUT_LINE('Procesado ' || v_contador || ': ' || 
                               v_vendedores(i).nombre || ' (RUT: ' || 
                               v_vendedores(i).rutvendedor || ') - Total: $' || 
                               TO_CHAR(v_total_pagar, '999G999G999'));
            
        EXCEPTION
            WHEN OTHERS THEN
                -- Registramos el error pero seguimos con el siguiente vendedor
                pkg_calculo_pagos.sp_registrar_error(
                    'sp_procesar_pagos_vendedores',
                    'Error procesando vendedor: ' || v_vendedores(i).rutvendedor || 
                    ' - ' || SQLERRM
                );
                DBMS_OUTPUT.PUT_LINE('ERROR procesando vendedor: ' || v_vendedores(i).nombre);
        END;
        
    END LOOP;
    
    -- guardamos los cambios
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Cantidad de VENDEDORES Procesados MES: ' || v_contador);
    DBMS_OUTPUT.PUT_LINE('Procedimiento PL/SQL terminado correctamente.');
    
EXCEPTION
    WHEN OTHERS THEN
        -- Error FATAL en el proceso, hacemos rollback
        ROLLBACK;
        pkg_calculo_pagos.sp_registrar_error(
            'sp_procesar_pagos_vendedores',
            'Error critico en proceso principal - ' || SQLERRM
        );
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('ERROR CRITICO: El proceso ha fallado.');
        DBMS_OUTPUT.PUT_LINE('Mensaje: ' || SQLERRM);
        RAISE;
END sp_procesar_pagos_vendedores;
/

-- BLOQUE ANONIMO PARA EJECUTAR EL PROCESO

PROMPT EJECUCION DEL PROCESO N2 - PAGOS VENDEDORES
PROMPT Periodo: SEPTIEMBRE 2020

SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_total_procesados NUMBER;
BEGIN
    -- Ejecutar procedimiento principal para Septiembre 2020
    sp_procesar_pagos_vendedores(9, 2020);
    
    -- Mostramos los resultados
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('RESULTADOS ALMACENADOS EN pago_vendedor');
    
    -- Contamos los registros procesados
    SELECT COUNT(*) INTO v_total_procesados FROM pago_vendedor;
    DBMS_OUTPUT.PUT_LINE('Total de registros en tabla: ' || v_total_procesados);
    
END;
/

-- Consultamos los resultados
PROMPT Resultados en tabla pago_vendedor:

SELECT 
    mes_anno,
    rutvendedor,
    SUBSTR(nomvendedor, 1, 30) AS nombre,
    TO_CHAR(sueldo_base, '999G999G999') AS sueldo_base,
    TO_CHAR(comision_mes, '999G999G999') AS comision_mes,
    TO_CHAR(colacion, '999G999G999') AS colacion,
    TO_CHAR(movilizacion, '999G999G999') AS movilizacion,
    TO_CHAR(prevision, '999G999G999') AS prevision,
    TO_CHAR(salud, '999G999G999') AS salud,
    TO_CHAR(total_pagar, '999G999G999') AS total_pagar
FROM pago_vendedor
ORDER BY rutvendedor;

-- Consultamos los errores si existen
PROMPT Errores registrados (si existen):

SELECT 
    correl_error,
    rutina_error,
    descrip_error
FROM error_procesos_mensuales
ORDER BY correl_error;

COMMIT;
