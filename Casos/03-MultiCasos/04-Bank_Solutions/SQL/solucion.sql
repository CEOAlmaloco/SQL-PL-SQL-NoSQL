
-- BANK SOLUTIONS - SOLUCIONES SQL COMPLETAS

-- Este archivo contiene las soluciones SQL para los 4 casos
-- de la institución financiera BANK SOLUTIONS



-- CASO 1: Vista - Clientes con Créditos de Monto Mayor al Promedio

-- Contexto: Vista para SBIF con información de créditos con 
-- monto mayor al promedio, incluyendo aporte a SBIF.


CREATE OR REPLACE VIEW V_CLIENTES_CREDIT_MAYOR_PROM AS
SELECT TO_CHAR(crc.fecha_otorga_cred,'MMYYYY') "MES TRANSACCIÓN",
       c.nombre_credito "TIPO CREDITO",
       SUM(crc.monto_credito) "MONTO SOLICITADO CREDITO",
       SUM(CASE WHEN crc.monto_credito BETWEEN 100000 AND 1000000 THEN ROUND(crc.monto_credito*0.01)
            WHEN crc.monto_credito BETWEEN 1000001 AND 2000000 THEN ROUND(crc.monto_credito*0.02)
            WHEN crc.monto_credito BETWEEN 2000001 AND 4000000 THEN ROUND(crc.monto_credito*0.03)
            WHEN crc.monto_credito BETWEEN 4000001 AND 6000000 THEN ROUND(crc.monto_credito*0.04)
       ELSE ROUND(crc.monto_credito*0.07) END) "APORTE A LA SBIF"
FROM credito_cliente crc 
JOIN credito c ON crc.cod_credito = c.cod_credito
WHERE crc.monto_credito > (SELECT ROUND(AVG(monto_credito))
                          FROM credito_cliente)
GROUP BY TO_CHAR(crc.fecha_otorga_cred,'MMYYYY'), c.nombre_credito
ORDER BY TO_CHAR(crc.fecha_otorga_cred,'MMYYYY'), c.nombre_credito
WITH READ ONLY;


-- CASO 2: Vista - Total de Créditos de Clientes por Año

-- Contexto: Vista que muestra el total de créditos que los 
-- clientes han solicitado durante el año anterior.


CREATE OR REPLACE VIEW V_TOTAL_CREDITOS_CLIENTES_POR_ANO AS
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


-- CASO 3: Vista - Clientes con Más Productos de Inversión

-- Contexto: Vista que muestra información de los clientes que 
-- poseen mayor cantidad de productos de inversión contratados.


CREATE OR REPLACE VIEW V_CLIENTES_CON_MAS_PROD_INV AS
SELECT EXTRACT(YEAR FROM SYSDATE) "AÑO TRIBUTARIO",
       TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || SUBSTR(c.snombre,1,1) || '. ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       COUNT(pic.nro_cliente) "TOTAL PROD. INV AFECTOS IMPTO",
       LPAD(TO_CHAR(SUM(pic.monto_total_ahorrado),'$999G999G999'),21, ' ') "MONTO TOTAL AHORRADO"
FROM cliente c 
JOIN producto_inversion_cliente pic ON c.nro_cliente = pic.nro_cliente
WHERE pic.cod_prod_inv IN(30,35,40,45,50,55)
AND c.nro_cliente IN (
    SELECT nro_cliente
    FROM producto_inversion_cliente
    GROUP BY nro_cliente
    HAVING COUNT(*) = (
        SELECT MAX(COUNT(*))
        FROM producto_inversion_cliente
        GROUP BY nro_cliente
    )
)
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
ORDER BY c.appaterno
WITH READ ONLY;


-- CASO 4: Consulta - Clientes con Productos de Inversión para SII

-- Contexto: Consulta para generar información de clientes 
-- dependientes que contrataron algún producto de inversión 
-- durante el año para el SII.


SELECT TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       pi.nombre_prod_inv "PRODUCTO DE INVERSION",
       TO_CHAR(pic.monto_total_ahorrado, '$999G999G999') "MONTO TOTAL AHORRADO"
FROM cliente c 
JOIN producto_inversion_cliente pic ON c.nro_cliente = pic.nro_cliente
JOIN producto_inversion pi ON pic.cod_prod_inv = pi.cod_prod_inv
WHERE EXTRACT(YEAR FROM pic.fecha_solic_prod) = EXTRACT(YEAR FROM SYSDATE)
AND c.cod_tipo_cliente = 1
ORDER BY c.appaterno;


-- FIN DE SOLUCIONES SQL PARA BANK SOLUTIONS


