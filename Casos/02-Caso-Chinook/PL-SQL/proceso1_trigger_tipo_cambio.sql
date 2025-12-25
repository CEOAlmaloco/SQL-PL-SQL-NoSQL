/*
PROCESO 1: TRIGGER PARA ACTUALIZACION DE PRECIOS POR TIPO DE CAMBIO

DESCRIPCION:
Este proceso implementa un trigger que actualiza automaticamente los valores
en detalle_boleta cuando se modifica el valorcompradolar de un producto.

REGLAS DE NEGOCIO:
1. Si el valor en dolar sube 10% o mas Y el producto es importado (procedencia <> 'N'):
   - Incrementar totallinea en 10%
   - NO modificar vunitario
   
2 Si no, entonce:
   - Disminuir vunitario en 20%
   - Disminuir totallinea en 20%

3. Validamos que todos los valores sean siempre positivos (Trigger de validacion)
*/

-- PASO 1: CREAR TRIGGER DE ACTUALIZACION

CREATE OR REPLACE TRIGGER trg_actualiza_precio_cambio
AFTER UPDATE OF valorcompradolar ON producto
FOR EACH ROW
WHEN (OLD.valorcompradolar IS NOT NULL AND NEW.valorcompradolar IS NOT NULL)
DECLARE
    -- Variables para calculos
    v_porcentaje_aumento NUMBER(8,2);
    v_es_importado BOOLEAN;
    
    -- Cursor para actualizar detalles de boletas
    CURSOR cur_detalle_boleta IS
        SELECT numboleta, codproducto, vunitario, totallinea, cantidad
        FROM detalle_boleta
        WHERE codproducto = :NEW.codproducto
        FOR UPDATE OF vunitario, totallinea;
        
    -- Record para almacenar datos del cursor
    TYPE t_detalle_rec IS RECORD (
        numboleta     detalle_boleta.numboleta%TYPE,
        codproducto   detalle_boleta.codproducto%TYPE,
        vunitario     detalle_boleta.vunitario%TYPE,
        totallinea    detalle_boleta.totallinea%TYPE,
        cantidad      detalle_boleta.cantidad%TYPE
    );
    
    v_detalle t_detalle_rec;
    v_nuevo_vunitario NUMBER(8);
    v_nuevo_totallinea NUMBER(8);
    v_registros_actualizados NUMBER := 0;
    
BEGIN
    -- Calcular porcentaje de aumento
    IF :OLD.valorcompradolar > 0 THEN
        v_porcentaje_aumento := ((:NEW.valorcompradolar - :OLD.valorcompradolar) / :OLD.valorcompradolar) * 100;
    ELSE
        v_porcentaje_aumento := 0;
    END IF;
    
    -- Verificamos si el producto es importado ono
    v_es_importado := (:NEW.procedencia <> 'N');
    
    -- Registramos informacion del cambio cmo si fuera un log de python
    DBMS_OUTPUT.PUT_LINE('TRIGGER ACTIVADO: Actualizacion de Tipo de Cambio');
    DBMS_OUTPUT.PUT_LINE('Producto: ' || :NEW.codproducto || ' - ' || :NEW.descripcion);
    DBMS_OUTPUT.PUT_LINE('Valor Anterior USD: ' || :OLD.valorcompradolar);
    DBMS_OUTPUT.PUT_LINE('Valor Nuevo USD: ' || :NEW.valorcompradolar);
    DBMS_OUTPUT.PUT_LINE('Porcentaje Cambio: ' || ROUND(v_porcentaje_aumento, 2) || '%');
    DBMS_OUTPUT.PUT_LINE('Procedencia: ' || :NEW.procedencia);
    
    -- Procesamos cada detalle de boleta
    FOR v_detalle IN cur_detalle_boleta LOOP
        
        -- Aplicamos REGLA 1: Aumento >= 10% Y producto importado
        IF v_porcentaje_aumento >= 10 AND v_es_importado THEN
            -- Incrementamos solo totallinea en 10%
            v_nuevo_vunitario := v_detalle.vunitario;
            v_nuevo_totallinea := ROUND(v_detalle.totallinea * 1.10);
            
            DBMS_OUTPUT.PUT_LINE('REGLA 1 aplicada: Aumento 10% en totallinea');
            
        ELSE
            -- REGLA 2: Disminuir ambos valores en 20%
            v_nuevo_vunitario := ROUND(v_detalle.vunitario * 0.80);
            v_nuevo_totallinea := ROUND(v_detalle.totallinea * 0.80);
            
            DBMS_OUTPUT.PUT_LINE('REGLA 2 aplicada: Reduccion 20% en vunitario y totallinea');
        END IF;
        
        -- Actualizamos el detalle de boleta
        UPDATE detalle_boleta
        SET vunitario = v_nuevo_vunitario,
            totallinea = v_nuevo_totallinea
        WHERE numboleta = v_detalle.numboleta
          AND codproducto = v_detalle.codproducto;
          
        v_registros_actualizados := v_registros_actualizados + 1;
        
        DBMS_OUTPUT.PUT_LINE('Boleta: ' || v_detalle.numboleta || 
                           ' | vunitario: ' || v_detalle.vunitario || ' -> ' || v_nuevo_vunitario ||
                           ' | totallinea: ' || v_detalle.totallinea || ' -> ' || v_nuevo_totallinea);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total registros actualizados: ' || v_registros_actualizados);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR en trigger trg_actualiza_precio_cambio: ' || SQLERRM);
        RAISE;
END trg_actualiza_precio_cambio;
/

-- PASO 2: CREAR TRIGGER DE VALIDACION

CREATE OR REPLACE TRIGGER trg_valida_valores_positivos
BEFORE INSERT OR UPDATE ON detalle_boleta
FOR EACH ROW
DECLARE
    ex_valor_negativo EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_valor_negativo, -20001);
BEGIN
    -- Validamos que vunitario sea positivo
    IF :NEW.vunitario IS NOT NULL AND :NEW.vunitario < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'ERROR: El valor unitario no puede ser negativo. ' ||
            'Boleta: ' || :NEW.numboleta || 
            ', Producto: ' || :NEW.codproducto ||
            ', Valor ingresado: ' || :NEW.vunitario);
    END IF;
    
    -- Validamos que totallinea sea positivo
    IF :NEW.totallinea IS NOT NULL AND :NEW.totallinea < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'ERROR: El total linea no puede ser negativo. ' ||
            'Boleta: ' || :NEW.numboleta || 
            ', Producto: ' || :NEW.codproducto ||
            ', Valor ingresado: ' || :NEW.totallinea);
    END IF;
    
    -- Validamos que cantidad sea positiva
    IF :NEW.cantidad IS NOT NULL AND :NEW.cantidad <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 
            'ERROR: La cantidad debe ser mayor a cero. ' ||
            'Boleta: ' || :NEW.numboleta || 
            ', Producto: ' || :NEW.codproducto ||
            ', Valor ingresado: ' || :NEW.cantidad);
    END IF;
    
    -- Validamos que descuento no sea negativo
    IF :NEW.descuento IS NOT NULL AND :NEW.descuento < 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 
            'ERROR: El descuento no puede ser negativo. ' ||
            'Boleta: ' || :NEW.numboleta || 
            ', Producto: ' || :NEW.codproducto ||
            ', Valor ingresado: ' || :NEW.descuento);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        -- volvemos a lanzar el error para que se muestre a nosotros
        RAISE;
END trg_valida_valores_positivos;
/

-- PASO 3: SCRIPT DE PRUEBAS

PROMPT PRUEBAS DEL PROCESO N°1 - ACTUALIZACION POR TIPO DE CAMBIO

SET SERVEROUTPUT ON SIZE UNLIMITED;

PROMPT ESTADO INICIAL DE LAS TABLAS

-- Mostramos productos antes de actualizaciones
SELECT 
    codproducto,
    SUBSTR(descripcion, 1, 40) AS descripcion,
    valorcomprapeso,
    vunitario,
    valorcompradolar,
    totalstock,
    stkseguridad,
    procedencia
FROM producto
WHERE codproducto IN (3, 5, 25)
ORDER BY codproducto;

-- Mostramos detalle_boleta antes de actualizaciones tmb
SELECT 
    numboleta,
    codproducto,
    vunitario,
    codpromocion,
    descri_prom,
    descuento,
    cantidad,
    totallinea
FROM detalle_boleta
WHERE codproducto IN (3, 5, 25)
ORDER BY numboleta, codproducto;

PROMPT EJECUTANDO ACTUALIZACIONES

-- Prueba 1: CASTROL EDGE 0W-30 946 (Codigo 3)
-- Valor anterior: 7.09 USD -> Nuevo: 6.0 USD (disminucion)
-- Entonces aplicamos REGLA 2: reduccion 20%
PROMPT PRUEBA 1: CASTROL EDGE 0W-30 946 (Producto 3)
PROMPT Nuevo valor: 6.0 USD

UPDATE producto
SET valorcompradolar = 6.0
WHERE codproducto = 3;


-- Prueba 2: HYUNDAI XTEER G7000 10W-40 (Codigo 5)
-- Valor anterior: 4.03 USD -> Nuevo: 10.0 USD (aumento > 10%)
-- Es importado (procedencia = 'I')
-- Entonces aplicamos REGLA 1: aumento 10% solo en totallinea
PROMPT PRUEBA 2: HYUNDAI XTEER G7000 10W-40 (Producto 5)
PROMPT Nuevo valor: 10.0 USD

UPDATE producto
SET valorcompradolar = 10.0
WHERE codproducto = 5;


-- Prueba 3: CAMBIO PASTILLAS FRENO SUZUKI ALTO (Codigo 25)
-- Valor anterior: NULL -> Nuevo: 2 USD
-- Es nacional (procedencia = 'N')
-- Este caso tiene valorcompradolar NULL inicialmente, entonces no se aplica ninguna regla
PROMPT PRUEBA 3: CAMBIO PASTILLAS FRENO SUZUKI ALTO (Producto 25)
PROMPT Nuevo valor: 2.0 USD (antes NULL)

-- Este update no activara el trigger porque el producto no tiene detalle_boleta :c
UPDATE producto
SET valorcompradolar = 2.0
WHERE codproducto = 25;


PROMPT ESTADO FINAL DE LAS TABLAS

-- Mostrar productos despues de actualizaciones
SELECT 
    codproducto,
    SUBSTR(descripcion, 1, 40) AS descripcion,
    valorcomprapeso,
    vunitario,
    valorcompradolar,
    procedencia
FROM producto
WHERE codproducto IN (3, 5, 25)
ORDER BY codproducto;


-- Mostrar detalle_boleta despues de actualizaciones
SELECT 
    numboleta,
    codproducto,
    vunitario,
    codpromocion,
    descri_prom,
    descuento,
    cantidad,
    totallinea
FROM detalle_boleta
WHERE codproducto IN (3, 5, 25)
ORDER BY numboleta, codproducto;

 
PROMPT FIN DE PRUEBAS DEL PROCESO N°1

COMMIT;
