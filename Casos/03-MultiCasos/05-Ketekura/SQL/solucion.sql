
-- CLÍNICA KETEKURA - SOLUCIONES SQL COMPLETAS

-- Este archivo contiene las soluciones SQL para los 5 casos
-- de la Clínica KETEKURA



-- CASO 1.1: Beneficio a pacientes de Fonasa e Isapres

-- Contexto: Rebaja del 20% en arancel por consulta médica 
-- para entidades de salud con más atenciones que el promedio 
-- diario del mes anterior.


SELECT 
    ts.tipo_sal_id AS "TIPO SALUD",
    ts.descripcion AS "DESCRIPCION TIPO SALUD",
    COUNT(a.ate_id) AS "TOTAL ATENCIONES"
FROM tipo_salud ts
JOIN salud s ON ts.tipo_sal_id = s.tipo_sal_id
JOIN paciente p ON s.sal_id = p.sal_id
JOIN atencion a ON p.pac_run = a.pac_run
WHERE TO_CHAR(a.fecha_atencion, 'MM/YYYY') = (
    SELECT TO_CHAR(MAX(fecha_atencion), 'MM/YYYY')
    FROM atencion
    WHERE fecha_atencion < TRUNC(SYSDATE, 'MM')
)
AND UPPER(ts.descripcion) IN ('FONASA', 'ISAPRE')
GROUP BY ts.tipo_sal_id, ts.descripcion
HAVING COUNT(a.ate_id) > (
    SELECT NVL(AVG(total_diario), 0)
    FROM (
        SELECT COUNT(*) / NULLIF(COUNT(DISTINCT TO_CHAR(fecha_atencion, 'DD')), 0) AS total_diario
        FROM atencion
        WHERE TO_CHAR(fecha_atencion, 'MM/YYYY') = (
            SELECT TO_CHAR(MAX(fecha_atencion), 'MM/YYYY')
            FROM atencion
            WHERE fecha_atencion < TRUNC(SYSDATE, 'MM')
        )
        GROUP BY TO_CHAR(fecha_atencion, 'DD')
    )
)
ORDER BY ts.tipo_sal_id ASC, ts.descripcion ASC;


-- CASO 1.2: Beneficio a pacientes de la tercera edad

-- Contexto: Descuento para pacientes de 65 o más años que 
-- efectuaron más de 4 consultas médicas durante el año.


SELECT 
    TO_CHAR(p.pac_run, '09G999G999') || '-' || UPPER(p.dv_run) AS "RUN PACIENTE",
    INITCAP(p.pnombre || ' ' || p.snombre || ' ' || p.apaterno || ' ' || p.amaterno) AS "NOMBRE PACIENTE",
    FLOOR(MONTHS_BETWEEN(SYSDATE, p.fecha_nacimiento) / 12) AS "EDAD",
    COUNT(a.ate_id) AS "TOTAL ATENCIONES AÑO",
    pd.porcentaje_descto || '%' AS "PORCENTAJE DESCUENTO",
    EXTRACT(YEAR FROM SYSDATE) + 1 AS "AÑO SIGUIENTE"
FROM paciente p
JOIN atencion a ON p.pac_run = a.pac_run
JOIN porc_descto_3ra_edad pd ON FLOOR(MONTHS_BETWEEN(SYSDATE, p.fecha_nacimiento) / 12) BETWEEN pd.anno_ini AND pd.anno_ter
WHERE EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE)
AND (FLOOR(MONTHS_BETWEEN(SYSDATE, p.fecha_nacimiento) / 12) >= 65 
     OR (FLOOR(MONTHS_BETWEEN(SYSDATE, p.fecha_nacimiento) / 12) = 64 
         AND EXTRACT(MONTH FROM SYSDATE) - EXTRACT(MONTH FROM p.fecha_nacimiento) >= 6))
GROUP BY p.pac_run, p.dv_run, p.pnombre, p.snombre, p.apaterno, p.amaterno, p.fecha_nacimiento, pd.porcentaje_descto
HAVING COUNT(a.ate_id) > 4
ORDER BY p.apaterno ASC;


-- CASO 2: Médicos con Especialidades de Baja Demanda

-- Contexto: Informe de médicos que poseen especialidades en 
-- las que se han efectuado menos de diez atenciones médicas 
-- durante el año anterior.


SELECT 
    e.nombre AS "ESPECIALIDAD",
    TO_CHAR(m.med_run, '09G999G999') || '-' || UPPER(m.dv_run) AS "RUN MEDICO",
    INITCAP(m.pnombre || ' ' || m.snombre || ' ' || m.apaterno || ' ' || m.amaterno) AS "NOMBRE MEDICO",
    COUNT(a.ate_id) AS "TOTAL ATENCIONES AÑO"
FROM especialidad e
JOIN especialidad_medico em ON e.esp_id = em.esp_id
JOIN medico m ON em.med_run = m.med_run
LEFT JOIN atencion a ON m.med_run = a.med_run
WHERE EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY e.nombre, m.med_run, m.dv_run, m.pnombre, m.snombre, m.apaterno, m.amaterno
HAVING COUNT(a.ate_id) < 10
ORDER BY e.nombre ASC, m.apaterno ASC;


-- CASO 3: Médicos para Servicio a la Comunidad

-- Contexto: Informe de médicos que efectuaron menos del máximo 
-- de atenciones médicas realizadas por los profesionales durante 
-- el año anterior. La información se almacena en MEDICOS_SERVICIO_COMUNIDAD.


-- Limpiar datos anteriores antes de insertar
DELETE FROM medicos_servicio_comunidad;
COMMIT;

INSERT INTO medicos_servicio_comunidad (
    med_run,
    nombre_medico,
    telefono_medico,
    correo_institucional,
    total_atenciones_ano,
    nombre_unidad
)
SELECT 
    m.med_run,
    INITCAP(m.pnombre || ' ' || m.snombre || ' ' || m.apaterno || ' ' || m.amaterno) AS nombre_medico,
    m.telefono,
    UPPER(SUBSTR(u.nombre, 1, 2)) || 
    UPPER(SUBSTR(m.apaterno, LENGTH(m.apaterno)-1, 2)) || 
    SUBSTR(TO_CHAR(m.telefono), -3) || 
    TO_CHAR(m.fecha_contrato, 'DDMM') || 
    '@medicocktk.cl' AS correo_institucional,
    COUNT(a.ate_id) AS total_atenciones_ano,
    u.nombre AS nombre_unidad
FROM medico m
JOIN unidad u ON m.uni_id = u.uni_id
JOIN atencion a ON m.med_run = a.med_run
WHERE EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY m.med_run, m.pnombre, m.snombre, m.apaterno, m.amaterno, m.telefono, m.fecha_contrato, u.nombre
HAVING COUNT(a.ate_id) < (
    SELECT MAX(total_atenciones)
    FROM (
        SELECT COUNT(a2.ate_id) AS total_atenciones
        FROM medico m2
        JOIN atencion a2 ON m2.med_run = a2.med_run
        WHERE EXTRACT(YEAR FROM a2.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) - 1
        GROUP BY m2.med_run
    )
)
ORDER BY u.nombre ASC, m.apaterno ASC;

COMMIT;

-- Consulta para visualizar la información almacenada
SELECT 
    nombre_unidad AS "UNIDAD",
    nombre_medico AS "NOMBRE MEDICO",
    telefono_medico AS "TELEFONO",
    correo_institucional AS "CORREO INSTITUCIONAL",
    total_atenciones_ano AS "TOTAL ATENCIONES AÑO"
FROM medicos_servicio_comunidad
ORDER BY nombre_unidad ASC, nombre_medico ASC;


-- CASO 4: Informes para Acreditación en Salud

-- Contexto: Dos informes para el proceso de acreditación que 
-- reflejan la historia de los últimos tres años.


-- INFORME 1: Meses con atenciones igual o mayor al promedio mensual
SELECT 
    TO_CHAR(a.fecha_atencion, 'MM/YYYY') AS "AÑO Y MES",
    COUNT(a.ate_id) AS "TOTAL ATENCIONES",
    TO_CHAR(SUM(pa.monto_atencion), '$999G999G999') AS "MONTO TOTAL ATENCIONES"
FROM atencion a
LEFT JOIN pago_atencion pa ON a.ate_id = pa.ate_id
WHERE EXTRACT(YEAR FROM a.fecha_atencion) IN (
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(YEAR FROM SYSDATE) - 1,
    EXTRACT(YEAR FROM SYSDATE) - 2
)
GROUP BY TO_CHAR(a.fecha_atencion, 'MM/YYYY'), TO_CHAR(a.fecha_atencion, 'YYYY/MM')
HAVING COUNT(a.ate_id) >= (
    SELECT AVG(total_mensual)
    FROM (
        SELECT COUNT(*) AS total_mensual
        FROM atencion
        WHERE EXTRACT(YEAR FROM fecha_atencion) IN (
            EXTRACT(YEAR FROM SYSDATE),
            EXTRACT(YEAR FROM SYSDATE) - 1,
            EXTRACT(YEAR FROM SYSDATE) - 2
        )
        GROUP BY TO_CHAR(fecha_atencion, 'MM/YYYY')
    )
)
ORDER BY TO_CHAR(a.fecha_atencion, 'YYYY/MM') ASC;

-- INFORME 2: Pacientes con morosidad mayor al promedio anual
SELECT 
    TO_CHAR(p.pac_run, '09G999G999') || '-' || UPPER(p.dv_run) AS "RUN PACIENTE",
    INITCAP(p.pnombre || ' ' || p.snombre || ' ' || p.apaterno || ' ' || p.amaterno) AS "NOMBRE PACIENTE",
    a.ate_id AS "ID ATENCION",
    TO_CHAR(pa.fecha_venc_pago, 'DD/MM/YYYY') AS "FECHA VENCIMIENTO PAGO",
    TO_CHAR(pa.fecha_pago, 'DD/MM/YYYY') AS "FECHA PAGO",
    GREATEST(0, pa.fecha_pago - pa.fecha_venc_pago) AS "DIAS MOROSIDAD",
    TO_CHAR(GREATEST(0, pa.fecha_pago - pa.fecha_venc_pago) * 2000, '$999G999G999') AS "VALOR MULTA"
FROM paciente p
JOIN atencion a ON p.pac_run = a.pac_run
JOIN pago_atencion pa ON a.ate_id = pa.ate_id
WHERE EXTRACT(YEAR FROM pa.fecha_pago) IN (
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(YEAR FROM SYSDATE) - 1,
    EXTRACT(YEAR FROM SYSDATE) - 2
)
AND pa.fecha_pago > pa.fecha_venc_pago
AND GREATEST(0, pa.fecha_pago - pa.fecha_venc_pago) > (
    SELECT AVG(dias_morosidad)
    FROM (
        SELECT GREATEST(0, fecha_pago - fecha_venc_pago) AS dias_morosidad
        FROM pago_atencion
        WHERE EXTRACT(YEAR FROM fecha_pago) IN (
            EXTRACT(YEAR FROM SYSDATE),
            EXTRACT(YEAR FROM SYSDATE) - 1,
            EXTRACT(YEAR FROM SYSDATE) - 2
        )
        AND fecha_pago > fecha_venc_pago
    )
)
ORDER BY pa.fecha_venc_pago ASC, GREATEST(0, pa.fecha_pago - pa.fecha_venc_pago) DESC;


-- CASO 5: Bonificación por Utilidades para Médicos

-- Contexto: Informe de médicos que efectuaron más de 7 atenciones 
-- durante el año para calcular bonificación del 5% de las ganancias.


SELECT 
    TO_CHAR(m.med_run, '09G999G999') || '-' || UPPER(m.dv_run) AS "RUN MEDICO",
    INITCAP(m.pnombre || ' ' || m.snombre || ' ' || m.apaterno || ' ' || m.amaterno) AS "NOMBRE MEDICO",
    COUNT(a.ate_id) AS "TOTAL ATENCIONES AÑO",
    TO_CHAR(
        (2250000000 * 0.05) / (
            SELECT COUNT(*)
            FROM (
                SELECT m2.med_run
                FROM medico m2
                JOIN atencion a2 ON m2.med_run = a2.med_run
                WHERE EXTRACT(YEAR FROM a2.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE)
                GROUP BY m2.med_run
                HAVING COUNT(a2.ate_id) > 7
            )
        ),
        '$999G999G999'
    ) AS "BONIFICACION POR UTILIDADES"
FROM medico m
JOIN atencion a ON m.med_run = a.med_run
WHERE EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY m.med_run, m.dv_run, m.pnombre, m.snombre, m.apaterno, m.amaterno
HAVING COUNT(a.ate_id) > 7
ORDER BY m.med_run ASC, m.apaterno ASC;

-- Nota: El monto de las ganancias acumuladas debe ser ingresado en forma paramétrica
-- Ejemplo: &ganancias_acumuladas = 2250000000


-- FIN DE SOLUCIONES SQL PARA CLÍNICA KETEKURA


