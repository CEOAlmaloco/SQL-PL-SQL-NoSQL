-- ALL THE BEST - SOLUCIONES SQL COMPLETAS
-- Este archivo contiene las soluciones SQL para los 6 casos
-- de la empresa ALL THE BEST

-- CASO 1: Clientes de Cumpleaños del Mes Siguiente
-- Contexto: Enviar correo mensual a jefes de área de atención 
-- a clientes de cada sucursal con clientes que estarán de 
-- cumpleaños el mes siguiente.
-- Nota: Para demostración se usa septiembre (mes con muchos cumpleaños)

SELECT 
    s.id_sucursal AS "ID SUCURSAL",
    r.nombre_region AS "REGION",
    TO_CHAR(c.numrun, '09G999G999') || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre, '') || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '')) AS "NOMBRE CLIENTE",
    EXTRACT(DAY FROM c.fecha_nacimiento) AS "DIA DE CUMPLEAÑOS"
FROM CLIENTE c
JOIN SUCURSAL_RETAIL s ON c.cod_region = s.cod_region 
    AND c.cod_provincia = s.cod_provincia 
    AND c.cod_comuna = s.cod_comuna
JOIN REGION r ON s.cod_region = r.cod_region
WHERE TO_CHAR(c.fecha_nacimiento, 'MM') = '09'
ORDER BY s.id_sucursal ASC, EXTRACT(DAY FROM c.fecha_nacimiento) ASC, c.appaterno ASC;

-- CASO 2: Informe de Transacciones y Puntos para SBIF
-- Contexto: Informe anual para SBIF con todas las transacciones 
-- realizadas con la tarjeta CATB y puntos acumulados del año anterior.

SELECT 
    TO_CHAR(c.numrun, '09G999G999') || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre, '') || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '')) AS "NOMBRE CLIENTE",
    TO_CHAR(NVL(SUM(CASE WHEN tt.cod_tptran_tarjeta = 101 THEN t.monto_transaccion ELSE 0 END), 0), '$999G999G999') AS "MONTO TOTAL COMPRAS",
    TO_CHAR(NVL(SUM(CASE WHEN tt.cod_tptran_tarjeta = 102 THEN t.monto_transaccion ELSE 0 END), 0), '$999G999G999') AS "MONTO TOTAL AVANCES",
    TO_CHAR(NVL(SUM(CASE WHEN tt.cod_tptran_tarjeta = 103 THEN t.monto_transaccion ELSE 0 END), 0), '$999G999G999') AS "MONTO TOTAL SUPER AVANCES",
    NVL(SUM(ROUND(t.monto_transaccion / 10000) * 250), 0) AS "TOTAL PUNTOS CIRCULO ALL THE BEST"
FROM CLIENTE c
LEFT JOIN TARJETA_CLIENTE tc ON c.numrun = tc.numrun
LEFT JOIN TRANSACCION_TARJETA_CLIENTE t ON tc.nro_tarjeta = t.nro_tarjeta
LEFT JOIN TIPO_TRANSACCION_TARJETA tt ON t.cod_tptran_tarjeta = tt.cod_tptran_tarjeta
WHERE EXTRACT(YEAR FROM t.fecha_transaccion) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY NVL(SUM(ROUND(t.monto_transaccion / 10000) * 250), 0) DESC, c.appaterno ASC;

-- CASO 3: Informe de Avances y Súper Avances para SBIF
-- Contexto: Informe mensual del año anterior con aportes a SBIF 
-- según la Ley de Operaciones de Avances y Súper Avances.
-- Nota: Para demostración se usa el año actual ya que los datos están en ese año

SELECT 
    TO_CHAR(t.fecha_transaccion, 'MM/YYYY') AS "MES TRANSACCION",
    tt.nombre_tptran_tarjeta AS "TIPO TRANSACCION",
    TO_CHAR(SUM(t.monto_total_transaccion), '$999G999G999') AS "MONTO TOTAL TRANSACCION",
    TO_CHAR(SUM(
        CASE 
            WHEN t.monto_total_transaccion BETWEEN 100000 AND 1000000 THEN ROUND(t.monto_total_transaccion * 0.01)
            WHEN t.monto_total_transaccion BETWEEN 1000001 AND 2000000 THEN ROUND(t.monto_total_transaccion * 0.02)
            WHEN t.monto_total_transaccion BETWEEN 2000001 AND 4000000 THEN ROUND(t.monto_total_transaccion * 0.03)
            WHEN t.monto_total_transaccion BETWEEN 4000001 AND 6000000 THEN ROUND(t.monto_total_transaccion * 0.04)
            ELSE ROUND(t.monto_total_transaccion * 0.07)
        END
    ), '$999G999G999') AS "APORTE A LA SBIF"
FROM TRANSACCION_TARJETA_CLIENTE t
JOIN TIPO_TRANSACCION_TARJETA tt ON t.cod_tptran_tarjeta = tt.cod_tptran_tarjeta
WHERE tt.cod_tptran_tarjeta IN (102, 103)
AND EXTRACT(YEAR FROM t.fecha_transaccion) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY TO_CHAR(t.fecha_transaccion, 'MM/YYYY'), TO_CHAR(t.fecha_transaccion, 'YYYYMM'), tt.nombre_tptran_tarjeta
ORDER BY TO_CHAR(t.fecha_transaccion, 'YYYYMM') ASC, tt.nombre_tptran_tarjeta ASC;

-- CASO 4: Categorización de Clientes por Monto Total
-- Contexto: Proceso anual que categoriza clientes según el monto 
-- total de compras, avances y súper avances realizados con tarjeta CATB.

SELECT 
    TO_CHAR(c.numrun, '09G999G999') || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre, '') || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '')) AS "NOMBRE CLIENTE",
    TO_CHAR(NVL(SUM(t.monto_transaccion), 0), '$999G999G999') AS "MONTO TOTAL TRANSACCIONES",
    CASE 
        WHEN NVL(SUM(t.monto_transaccion), 0) BETWEEN 0 AND 100001 THEN 'SIN CATEGORIZACION'
        WHEN NVL(SUM(t.monto_transaccion), 0) BETWEEN 100000 AND 1000000 THEN 'BRONCE'
        WHEN NVL(SUM(t.monto_transaccion), 0) BETWEEN 1000001 AND 4000000 THEN 'PLATA'
        WHEN NVL(SUM(t.monto_transaccion), 0) BETWEEN 4000001 AND 8000000 THEN 'SILVER'
        WHEN NVL(SUM(t.monto_transaccion), 0) BETWEEN 8000001 AND 15000000 THEN 'GOLD'
        WHEN NVL(SUM(t.monto_transaccion), 0) > 15000000 THEN 'PLATINUM'
        ELSE 'SIN CATEGORIZACION'
    END AS "CATEGORIZACIÓN CLIENTE"
FROM CLIENTE c
LEFT JOIN TARJETA_CLIENTE tc ON c.numrun = tc.numrun
LEFT JOIN TRANSACCION_TARJETA_CLIENTE t ON tc.nro_tarjeta = t.nro_tarjeta
WHERE EXTRACT(YEAR FROM t.fecha_transaccion) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY NVL(SUM(t.monto_transaccion), 0) DESC, c.appaterno ASC;

-- CASO 5: Informe Resumen de Súper Avances para SII
-- Contexto: Informe resumen anual de súper avances vigentes 
-- para enviar al SII la primera semana de marzo.
-- Nota: Muestra todos los súper avances (vigente = con cuotas pendientes)

SELECT 
    EXTRACT(YEAR FROM SYSDATE) + 1 AS "AÑO TRIBUTARIO",
    TO_CHAR(c.numrun, '09G999G999') || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre, '') || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '')) AS "NOMBRE CLIENTE",
    COUNT(DISTINCT t.nro_transaccion) AS "CANTIDAD SUPER AVANCES VIGENTES",
    TO_CHAR(SUM(t.monto_transaccion), '$999G999G999') AS "MONTO TOTAL SUPER AVANCES VIGENTES"
FROM CLIENTE c
JOIN TARJETA_CLIENTE tc ON c.numrun = tc.numrun
JOIN TRANSACCION_TARJETA_CLIENTE t ON tc.nro_tarjeta = t.nro_tarjeta
JOIN TIPO_TRANSACCION_TARJETA tt ON t.cod_tptran_tarjeta = tt.cod_tptran_tarjeta
WHERE tt.cod_tptran_tarjeta = 103
AND EXTRACT(YEAR FROM t.fecha_transaccion) = EXTRACT(YEAR FROM SYSDATE)
AND EXISTS (
    SELECT 1
    FROM CUOTA_TRANSAC_TARJETA_CLIENTE ct
    WHERE ct.nro_tarjeta = t.nro_tarjeta
    AND ct.nro_transaccion = t.nro_transaccion
    AND ct.fecha_venc_cuota > SYSDATE
)
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY c.appaterno ASC;

-- CASO 6: Informes de Balance para SBIF
-- Contexto: Dos informes obligatorios para SBIF sobre activos 
-- del balance anual (detalle por cliente y resumen por sucursal).

-- INFORME 1: Detalle de todos los clientes que poseen tarjeta CATB
SELECT 
    s.id_sucursal AS "ID SUCURSAL",
    r.nombre_region AS "REGION",
    TO_CHAR(c.numrun, '09G999G999') || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre, '') || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '')) AS "NOMBRE CLIENTE",
    COUNT(CASE WHEN tt.cod_tptran_tarjeta = 101 THEN 1 END) AS "CANTIDAD COMPRAS",
    TO_CHAR(SUM(CASE WHEN tt.cod_tptran_tarjeta = 101 THEN t.monto_transaccion ELSE 0 END), '$999G999G999') AS "VALOR TOTAL COMPRAS",
    COUNT(CASE WHEN tt.cod_tptran_tarjeta = 102 THEN 1 END) AS "CANTIDAD AVANCES",
    TO_CHAR(SUM(CASE WHEN tt.cod_tptran_tarjeta = 102 THEN t.monto_transaccion ELSE 0 END), '$999G999G999') AS "VALOR TOTAL AVANCES",
    COUNT(CASE WHEN tt.cod_tptran_tarjeta = 103 THEN 1 END) AS "CANTIDAD SUPER AVANCES",
    TO_CHAR(SUM(CASE WHEN tt.cod_tptran_tarjeta = 103 THEN t.monto_transaccion ELSE 0 END), '$999G999G999') AS "VALOR TOTAL SUPER AVANCES"
FROM CLIENTE c
JOIN TARJETA_CLIENTE tc ON c.numrun = tc.numrun
LEFT JOIN TRANSACCION_TARJETA_CLIENTE t ON tc.nro_tarjeta = t.nro_tarjeta
LEFT JOIN TIPO_TRANSACCION_TARJETA tt ON t.cod_tptran_tarjeta = tt.cod_tptran_tarjeta
JOIN SUCURSAL_RETAIL s ON c.cod_region = s.cod_region 
    AND c.cod_provincia = s.cod_provincia 
    AND c.cod_comuna = s.cod_comuna
JOIN REGION r ON s.cod_region = r.cod_region
WHERE EXTRACT(YEAR FROM t.fecha_transaccion) = 2024
GROUP BY s.id_sucursal, r.nombre_region, c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY r.nombre_region ASC, s.id_sucursal ASC, c.appaterno ASC;

-- INFORME 2: Resumen por sucursal de las transacciones
SELECT 
    r.nombre_region AS "REGION",
    s.direccion AS "DIRECCION SUCURSAL",
    COUNT(CASE WHEN tt.cod_tptran_tarjeta = 101 THEN 1 END) AS "CANTIDAD COMPRAS",
    TO_CHAR(SUM(CASE WHEN tt.cod_tptran_tarjeta = 101 THEN t.monto_transaccion ELSE 0 END), '$999G999G999') AS "VALOR TOTAL COMPRAS",
    COUNT(CASE WHEN tt.cod_tptran_tarjeta = 102 THEN 1 END) AS "CANTIDAD AVANCES",
    TO_CHAR(SUM(CASE WHEN tt.cod_tptran_tarjeta = 102 THEN t.monto_transaccion ELSE 0 END), '$999G999G999') AS "VALOR TOTAL AVANCES",
    COUNT(CASE WHEN tt.cod_tptran_tarjeta = 103 THEN 1 END) AS "CANTIDAD SUPER AVANCES",
    TO_CHAR(SUM(CASE WHEN tt.cod_tptran_tarjeta = 103 THEN t.monto_transaccion ELSE 0 END), '$999G999G999') AS "VALOR TOTAL SUPER AVANCES"
FROM SUCURSAL_RETAIL s
JOIN REGION r ON s.cod_region = r.cod_region
LEFT JOIN CLIENTE c ON s.cod_region = c.cod_region 
    AND s.cod_provincia = c.cod_provincia 
    AND s.cod_comuna = c.cod_comuna
LEFT JOIN TARJETA_CLIENTE tc ON c.numrun = tc.numrun
LEFT JOIN TRANSACCION_TARJETA_CLIENTE t ON tc.nro_tarjeta = t.nro_tarjeta
LEFT JOIN TIPO_TRANSACCION_TARJETA tt ON t.cod_tptran_tarjeta = tt.cod_tptran_tarjeta
WHERE EXTRACT(YEAR FROM t.fecha_transaccion) = 2024
GROUP BY r.nombre_region, s.direccion, s.id_sucursal
ORDER BY r.nombre_region ASC, s.id_sucursal ASC;
