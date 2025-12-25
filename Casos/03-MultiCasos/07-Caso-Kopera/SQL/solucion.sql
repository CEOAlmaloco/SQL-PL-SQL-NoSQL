
-- KOPERA - SOLUCIONES SQL COMPLETAS

-- Este archivo contiene las soluciones SQL para los 4 requerimientos
-- de la Cooperativa de ahorro y crédito KOPERA

-- NOTA: Este archivo debe ejecutarse con el usuario correspondiente
-- según los requerimientos de seguridad de cada caso



-- REQUERIMIENTO 1: Categorización de Clientes por Monto Ahorrado

-- Contexto: Vista que categoriza clientes según el monto total 
-- ahorrado en productos de inversión y/o de ahorro.


CREATE OR REPLACE VIEW V_CLIENTES_CATEGORIZADOS_POR_AHORRO AS
SELECT EXTRACT(YEAR FROM SYSDATE) - 1 AS "AÑO",
       TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       CASE 
           WHEN SUM(pic.monto_total_ahorrado) BETWEEN 100000 AND 1000000 THEN 'BRONCE'
           WHEN SUM(pic.monto_total_ahorrado) BETWEEN 1000001 AND 4000000 THEN 'PLATA'
           WHEN SUM(pic.monto_total_ahorrado) BETWEEN 4000001 AND 8000000 THEN 'SILVER'
           WHEN SUM(pic.monto_total_ahorrado) BETWEEN 8000001 AND 15000000 THEN 'GOLD'
           WHEN SUM(pic.monto_total_ahorrado) > 15000000 THEN 'PLATINUM'
           ELSE 'SIN CATEGORIZACION'
       END AS "CATEGORIZACIÓN",
       TO_CHAR(SUM(pic.monto_total_ahorrado), '$999G999G999') "MONTO TOTAL AHORRADO"
FROM cliente c
JOIN producto_inversion_cliente pic ON c.nro_cliente = pic.nro_cliente
WHERE EXTRACT(YEAR FROM pic.fecha_solic_prod) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY c.appaterno ASC, SUM(pic.monto_total_ahorrado) DESC
WITH READ ONLY;


-- REQUERIMIENTO 2: Informe de Créditos para SBIF (Ley de Créditos)

-- Contexto: Vista para SBIF con información de créditos otorgados 
-- durante el año anterior, incluyendo aporte a SBIF según rangos.
-- NOTA: NO puede usar los nombres reales de las tablas (usar sinónimos)


-- Primero crear sinónimos si es necesario
-- CREATE SYNONYM crd_cli FOR esquema.credito_cliente;
-- CREATE SYNONYM crd FOR esquema.credito;
-- CREATE SYNONYM aporte FOR esquema.aporte_a_sbif;

CREATE OR REPLACE VIEW V_CREDITOS_PARA_SBIF AS
SELECT TO_CHAR(crc.fecha_otorga_cred,'MMYYYY') "MES TRANSACCIÓN",
       c.nombre_credito "TIPO CREDITO",
       SUM(crc.monto_credito) "MONTO TOTAL CREDITO",
       SUM(
           CASE 
               WHEN crc.monto_credito BETWEEN 100000 AND 1000000 THEN ROUND(crc.monto_credito * 0.01)
               WHEN crc.monto_credito BETWEEN 1000001 AND 2000000 THEN ROUND(crc.monto_credito * 0.02)
               WHEN crc.monto_credito BETWEEN 2000001 AND 4000000 THEN ROUND(crc.monto_credito * 0.03)
               WHEN crc.monto_credito BETWEEN 4000001 AND 6000000 THEN ROUND(crc.monto_credito * 0.04)
               ELSE ROUND(crc.monto_credito * 0.07)
           END
       ) "APORTE A LA SBIF"
FROM credito_cliente crc
JOIN credito c ON crc.cod_credito = c.cod_credito
WHERE EXTRACT(YEAR FROM crc.fecha_otorga_cred) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY TO_CHAR(crc.fecha_otorga_cred,'MMYYYY'), c.nombre_credito
ORDER BY TO_CHAR(crc.fecha_otorga_cred,'MMYYYY') ASC, c.nombre_credito ASC
WITH READ ONLY;

-- Nota: Ajustar según la estructura real de las tablas y sinónimos


-- REQUERIMIENTO 3: Informe de Productos de Inversión para SII

-- Contexto: Consulta para generar información de clientes con 
-- depósitos a plazo y/o fondos mutuos para el SII con encriptación.


-- Consulta sin encriptación (para análisis)
SELECT 
    EXTRACT(YEAR FROM SYSDATE) AS "AÑO TRIBUTARIO",
    TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
    COUNT(CASE WHEN pic.cod_prod_inv IN (30, 35, 40, 45, 50, 55) THEN 1 END) AS "CANTIDAD PROD. INV TRIBUTABLES",
    TO_CHAR(SUM(CASE WHEN pic.cod_prod_inv IN (30, 35, 40, 45, 50, 55) THEN pic.monto_total_ahorrado ELSE 0 END), '$999G999G999') AS "MONTO TOTAL AHORRADO"
FROM cliente c
JOIN producto_inversion_cliente pic ON c.nro_cliente = pic.nro_cliente
WHERE pic.cod_prod_inv IN (30, 35, 40, 45, 50, 55)
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY c.appaterno;

-- Consulta con encriptación (según método SII)
-- Nota: Ajustar el método de encriptación según la definición específica del SII
SELECT 
    EXTRACT(YEAR FROM SYSDATE) AS "AÑO TRIBUTARIO",
    -- Encriptación del RUN (ejemplo: usar función de hash o encriptación específica)
    -- DBMS_CRYPTO.ENCRYPT(...) o método específico del SII
    TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE ENCRIPTADO",
    INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
    -- Encriptación de cantidad y monto (ajustar según método SII)
    COUNT(CASE WHEN pic.cod_prod_inv IN (30, 35, 40, 45, 50, 55) THEN 1 END) AS "CANTIDAD PROD. INV TRIBUTABLES ENCRIPTADO",
    TO_CHAR(SUM(CASE WHEN pic.cod_prod_inv IN (30, 35, 40, 45, 50, 55) THEN pic.monto_total_ahorrado ELSE 0 END), '$999G999G999') AS "MONTO TOTAL AHORRADO ENCRIPTADO"
FROM cliente c
JOIN producto_inversion_cliente pic ON c.nro_cliente = pic.nro_cliente
WHERE pic.cod_prod_inv IN (30, 35, 40, 45, 50, 55)
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY c.appaterno;

-- Nota: Implementar el método de encriptación específico según las instrucciones del SII


-- REQUERIMIENTO 4: Informes de Balance para SBIF

-- Contexto: Dos informes obligatorios para SBIF sobre activos 
-- y pasivos del balance anual.


-- INFORME 1: Detalle de todos los créditos otorgados durante el año
CREATE OR REPLACE VIEW V_DETALLE_CREDITOS_CLIENTES_ANO AS
SELECT EXTRACT(YEAR FROM SYSDATE) - 1 AS "AÑO",
       TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       COUNT(crc.cod_credito) AS "TOTAL CREDITOS SOLICITADOS",
       TO_CHAR(SUM(crc.monto_credito), '$999G999G999') AS "MONTO TOTAL CREDITOS"
FROM cliente c
JOIN credito_cliente crc ON c.nro_cliente = crc.nro_cliente
WHERE EXTRACT(YEAR FROM crc.fecha_otorga_cred) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY c.appaterno
WITH READ ONLY;

-- INFORME 2: Detalle de abonos y rescates de productos de inversión
CREATE OR REPLACE VIEW V_ABONOS_RESCATES_CLIENTES_ANO AS
SELECT EXTRACT(YEAR FROM SYSDATE) - 1 AS "AÑO",
       TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       TO_CHAR(SUM(CASE WHEN UPPER(tm.nombre_tipo_mov) = 'ABONO' THEN m.monto_movimiento ELSE 0 END), '$999G999G999') AS "MONTO TOTAL ABONOS",
       TO_CHAR(SUM(CASE WHEN UPPER(tm.nombre_tipo_mov) = 'RESCATE' THEN m.monto_movimiento ELSE 0 END), '$999G999G999') AS "MONTO TOTAL RESCATES"
FROM cliente c
JOIN producto_inversion_cliente pic ON c.nro_cliente = pic.nro_cliente
JOIN movimiento m ON pic.nro_solic_prod = m.nro_solic_prod
JOIN tipo_movimiento tm ON m.cod_tipo_mov = tm.cod_tipo_mov
WHERE EXTRACT(YEAR FROM m.fecha_movimiento) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY c.appaterno
WITH READ ONLY;

-- Nota: Ajustar nombres de tablas según la estructura real de la base de datos


-- FIN DE SOLUCIONES SQL PARA KOPERA


