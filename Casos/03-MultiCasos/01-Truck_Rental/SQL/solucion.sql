-- TRUCK RENTAL - SOLUCIONES SQL COMPLETAS
-- Este archivo contiene las soluciones SQL para los 7 casos
-- de la empresa TRUCK RENTAL

-- CASO 1: Clientes de Cumpleaños del Día Siguiente
-- Contexto: Enviar correo diario a las 17:00 h. con los 
-- clientes que estarán de cumpleaños el día siguiente.
-- Nota: La consulta usa SYSDATE+1 para buscar cumpleaños de mañana
-- Para demostración, se muestra ejemplo con fecha 18/08 (muchos cumpleaños)

SELECT 
    TO_CHAR(c.numrun_cli, '09G999G999') || '-' || UPPER(c.dvrun_cli) AS "RUN CLIENTE",
    INITCAP(c.pnombre_cli || ' ' || NVL(c.snombre_cli, '') || ' ' || c.appaterno_cli || ' ' || c.apmaterno_cli) AS "NOMBRE COMPLETO",
    TO_CHAR(c.fecha_nac_cli, 'DD/MM/YYYY') AS "FECHA NACIMIENTO"
FROM cliente c
WHERE c.fecha_nac_cli IS NOT NULL
AND TO_CHAR(c.fecha_nac_cli, 'MMDD') = '0818'
ORDER BY c.appaterno_cli ASC;

-- CASO 2: Aumento de Movilización por Sueldo Base
-- Contexto: Informe online del aumento en el valor de la 
-- movilización mensual según el sueldo base del empleado.
-- Por cada $100.000 del sueldo base = 1% de aumento.
-- Nota: La movilización actual se calcula como el 7% del sueldo base

SELECT 
    TO_CHAR(e.numrun_emp, '09G999G999') || '-' || UPPER(e.dvrun_emp) AS "RUN EMPLEADO",
    INITCAP(e.pnombre_emp || ' ' || NVL(e.snombre_emp, '') || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE COMPLETO",
    TO_CHAR(e.sueldo_base, '$999G999G999') AS "SUELDO BASE",
    TRUNC(e.sueldo_base / 100000, 0) || '%' AS "PORCENTAJE MOVILIZACION",
    TO_CHAR(e.sueldo_base * 0.07, '$999G999G999') AS "VALOR ACTUAL MOVILIZACION",
    TO_CHAR((e.sueldo_base * 0.07) * (1 + (e.sueldo_base / 100000) / 100), '$999G999G999') AS "NUEVO VALOR MOVILIZACION",
    TO_CHAR((e.sueldo_base * 0.07) * ((e.sueldo_base / 100000) / 100), '$999G999G999') AS "AUMENTO MOVILIZACION"
FROM empleado e
ORDER BY (e.sueldo_base / 100000) DESC;

-- CASO 3: Generación de Usuarios y Claves
-- Contexto: Módulo de seguridad para generar usuarios y 
-- claves únicos para cada empleado según reglas específicas.
-- Regla Usuario: 3 primeras letras nombre + largo nombre + * + 
--                último dígito sueldo + dígito verificador + años trabajando
-- Regla Clave: 3er dígito run + (año contrato + 2) + 
--              (últimos 3 dígitos sueldo - 1) + últimas 2 letras apellido + mes actual

SELECT 
    TO_CHAR(e.numrun_emp, '09G999G999') || '-' || UPPER(e.dvrun_emp) AS "RUN EMPLEADO",
    INITCAP(e.pnombre_emp || ' ' || NVL(e.snombre_emp, '') || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE COMPLETO",
    UPPER(SUBSTR(e.pnombre_emp, 1, 3)) || 
    LENGTH(e.pnombre_emp) || 
    '*' || 
    SUBSTR(TO_CHAR(e.sueldo_base), -1) || 
    UPPER(e.dvrun_emp) || 
    (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM e.fecha_contrato)) AS "NOMBRE USUARIO",
    SUBSTR(TO_CHAR(e.numrun_emp), 3, 1) || 
    TO_CHAR(EXTRACT(YEAR FROM e.fecha_contrato) + 2) || 
    TO_CHAR(TO_NUMBER(SUBSTR(TO_CHAR(e.sueldo_base), -3)) - 1) || 
    UPPER(SUBSTR(e.appaterno_emp, -2)) || 
    TO_CHAR(SYSDATE, 'MM') AS "CLAVE"
FROM empleado e
ORDER BY e.appaterno_emp ASC;

-- CASO 4: Rebaja de Tarifas por Antigüedad
-- Contexto: Proceso automático que rebaja valores de arriendo 
-- y garantía según la antigüedad del camión (más de 5 años).
-- Rebaja = antigüedad del camión en años (ej: 8 años = 8% de rebaja)

SELECT 
    c.nro_patente AS "PATENTE",
    EXTRACT(YEAR FROM SYSDATE) - c.anio AS "AÑO ANTIGUEDAD",
    TO_CHAR(c.valor_arriendo_dia, '$999G999G999') AS "VALOR ARRIEND",
    TO_CHAR(c.valor_garantia_dia, '$999G999G999') AS "VALOR GARANTI",
    TO_CHAR(c.valor_arriendo_dia * (1 - ((EXTRACT(YEAR FROM SYSDATE) - c.anio) / 100)), '$999G999G999') AS "VALOR ARRIEND",
    TO_CHAR(NVL(c.valor_garantia_dia * (1 - ((EXTRACT(YEAR FROM SYSDATE) - c.anio) / 100)), 0), '$999G999G999') AS "VALOR GARANTI",
    EXTRACT(YEAR FROM SYSDATE) AS "AÑO PROCESO"
FROM camion c
WHERE c.anio IS NOT NULL
AND (EXTRACT(YEAR FROM SYSDATE) - c.anio) > 5
ORDER BY (EXTRACT(YEAR FROM SYSDATE) - c.anio) DESC, c.nro_patente ASC;

-- CASO 5: Multas por Retraso en Devolución
-- Contexto: Proceso automático que mensualmente genere la 
-- información de las multas de arriendos del mes anterior.
-- Nota: Se considera atraso si la devolución es después del día
-- en que debería devolver (fecha_ini + dias_solicitados)

SELECT 
    a.nro_patente AS "PATENTE CAMION",
    TO_CHAR(a.fecha_ini_arriendo, 'DD/MM/YYYY') AS "FECHA INI ARRIENDO",
    a.dias_solicitados AS "TOTAL DIAS ARRIENDO",
    TO_CHAR(a.fecha_devolucion, 'DD/MM/YYYY') AS "FECHA DEVOLUCION",
    (a.fecha_devolucion - (a.fecha_ini_arriendo + a.dias_solicitados)) AS "DIAS ATRASO",
    TO_CHAR((a.fecha_devolucion - (a.fecha_ini_arriendo + a.dias_solicitados)) * 50000, '$999G999G999') AS "MONTO MULTA"
FROM arriendo_camion a
WHERE a.fecha_devolucion IS NOT NULL
AND a.dias_solicitados IS NOT NULL
AND a.fecha_devolucion > (a.fecha_ini_arriendo + a.dias_solicitados)
ORDER BY a.fecha_ini_arriendo ASC, a.nro_patente ASC;

-- CASO 6: Bonificación por Utilidades
-- Contexto: Informe online de bonificación por utilidades 
-- para empleados que arrendaron más camiones que el promedio.
-- Se considera que un empleado "arrendó" un camión si es 
-- responsable del camión que fue arrendado.
-- Nota: Se usa el mes de agosto como ejemplo

SELECT 
    TO_CHAR(e.numrun_emp, '09G999G999') || '-' || UPPER(e.dvrun_emp) AS "RUN EMPLEADO",
    INITCAP(e.pnombre_emp || ' ' || NVL(e.snombre_emp, '') || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE COMPLETO",
    TO_CHAR(e.sueldo_base, '$999G999G999') AS "SUELDO BASE",
    TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS "FECHA PROCESO",
    TO_CHAR(
        5000000 * 
        CASE 
            WHEN e.sueldo_base BETWEEN 320000 AND 450000 THEN 0.005
            WHEN e.sueldo_base BETWEEN 450001 AND 600000 THEN 0.0035
            WHEN e.sueldo_base BETWEEN 600001 AND 900000 THEN 0.0025
            WHEN e.sueldo_base BETWEEN 900001 AND 1800000 THEN 0.0015
            WHEN e.sueldo_base > 1800000 THEN 0.001
            ELSE 0
        END,
        '$999G999G999'
    ) AS "BONIFICACION POR UTILIDADES"
FROM empleado e
WHERE (
    SELECT COUNT(*)
    FROM arriendo_camion ac
    JOIN camion c ON ac.nro_patente = c.nro_patente
    WHERE c.numrun_emp = e.numrun_emp
    AND EXTRACT(YEAR FROM ac.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
    AND EXTRACT(MONTH FROM ac.fecha_ini_arriendo) = 8
) > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM arriendo_camion ac2
        JOIN camion c2 ON ac2.nro_patente = c2.nro_patente
        WHERE EXTRACT(YEAR FROM ac2.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
        AND EXTRACT(MONTH FROM ac2.fecha_ini_arriendo) = 8
        AND c2.numrun_emp IS NOT NULL
        GROUP BY c2.numrun_emp
    )
)
ORDER BY e.appaterno_emp ASC;

-- CASO 7: Bonificación Extra de Movilización
-- Contexto: Informe para el SII con información de empleados 
-- que reciben bonificación extra de movilización por vivir 
-- en comunas lejanas: María Pinto, Curacaví, El Monte, Paine, Pirque
-- La movilización por ley se calcula como el 7% del sueldo base

SELECT 
    TO_CHAR(e.numrun_emp, '09G999G999') || '-' || UPPER(e.dvrun_emp) AS "RUN EMPLEADO",
    INITCAP(e.pnombre_emp || ' ' || NVL(e.snombre_emp, '') || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE COMPLETO",
    c.nombre_comuna AS "COMUNA",
    TO_CHAR(e.sueldo_base, '$999G999G999') AS "SUELDO BASE",
    TO_CHAR(e.sueldo_base * 0.07, '$999G999G999') AS "MOVILIZACION POR LEY",
    TO_CHAR(
        e.sueldo_base * 
        CASE 
            WHEN e.sueldo_base >= 450000 
            THEN TO_NUMBER(SUBSTR(TO_CHAR(e.sueldo_base), 1, 1)) / 100
            ELSE TO_NUMBER(SUBSTR(TO_CHAR(e.sueldo_base), 1, 2)) / 100
        END,
        '$999G999G999'
    ) AS "BONIFICACION EXTRA",
    TO_CHAR(
        (e.sueldo_base * 0.07) + 
        (e.sueldo_base * 
         CASE 
             WHEN e.sueldo_base >= 450000 
             THEN TO_NUMBER(SUBSTR(TO_CHAR(e.sueldo_base), 1, 1)) / 100
             ELSE TO_NUMBER(SUBSTR(TO_CHAR(e.sueldo_base), 1, 2)) / 100
         END),
        '$999G999G999'
    ) AS "TOTAL MOVILIZACION"
FROM empleado e
JOIN comuna c ON e.id_comuna = c.id_comuna
WHERE c.nombre_comuna IN ('María Pinto', 'Curacaví', 'El Monte', 'Paine', 'Pirque')
   OR c.nombre_comuna IN ('Mar�a Pinto', 'Curacav�', 'El Monte', 'Paine', 'Pirque')
ORDER BY e.appaterno_emp ASC;
