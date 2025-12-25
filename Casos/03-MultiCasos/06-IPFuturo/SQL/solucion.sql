-- IPFUTURO (TUFUTURO) - SOLUCIONES SQL COMPLETAS
-- Este archivo contiene las soluciones SQL para los 6 casos
-- del instituto profesional TUFUTURO

-- CASO 1: Presupuesto de Publicidad por Carrera
-- Contexto: Informe que muestre la asignación de presupuesto
-- de publicidad por carrera considerando un monto paramétrico
-- por alumno matriculado.
-- &monto_publicidad 30200 <- ejemplo

SELECT
    c.carreraid AS "ID CARRERA",
    c.descripcion AS "NOMBRE CARRERA",
    COUNT(a.alumnoid) AS "TOTAL ALUMNOS MATRICULADOS",
    TO_CHAR(COUNT(a.alumnoid) * &monto_publicidad, '$999G999G999') AS "PRESUPUESTO PUBLICIDAD"
FROM carrera c
LEFT JOIN alumno a ON c.carreraid = a.carreraid
GROUP BY c.carreraid, c.descripcion
ORDER BY COUNT(a.alumnoid) DESC, c.carreraid ASC;

-- CASO 2: Beneficio para Carreras con Más de 4 Alumnos
-- Contexto: Informe de carreras que poseen más de cuatro
-- alumnos matriculados.

SELECT
    c.carreraid AS "CODIGO CARRERA",
    c.descripcion AS "NOMBRE CARRERA",
    COUNT(a.alumnoid) AS "TOTAL ALUMNOS"
FROM carrera c
JOIN alumno a ON c.carreraid = a.carreraid
GROUP BY c.carreraid, c.descripcion
HAVING COUNT(a.alumnoid) > 4
ORDER BY c.carreraid ASC;

-- CASO 3: Bonificación para Jefes
-- Contexto: Informe que muestre los jefes que serán
-- beneficiados con bono especial basado en el salario
-- máximo de sus empleados y el número de empleados a cargo.

SELECT
    TO_CHAR(ej.run_emp, '09G999G999') || '-' || UPPER(ej.dv_run) AS "RUN JEFE",
    INITCAP(ej.nombre || ' ' || ej.apaterno || ' ' || ej.amaterno) AS "NOMBRE COMPLETO",
    COUNT(e.run_emp) AS "TOTAL EMPLEADOS A CARGO",
    TO_CHAR(MAX(e.salario), '$999G999G999') AS "SALARIO MAXIMO",
    TO_CHAR(COUNT(e.run_emp) * 10, '999') || '%' AS "PORCENTAJE BONIFICACION",
    TO_CHAR(MAX(e.salario) * (COUNT(e.run_emp) * 10 / 100), '$999G999G999') AS "MONTO BONIFICACION"
FROM empleado ej
JOIN empleado e ON ej.run_emp = e.run_jefe
GROUP BY ej.run_emp, ej.dv_run, ej.nombre, ej.apaterno, ej.amaterno
ORDER BY COUNT(e.run_emp) ASC;

-- CASO 4: Informe de Salarios por Nivel de Escolaridad para CNA
-- Contexto: Informe que muestre un resumen, por nivel de escolaridad,
-- que especifique el total de empleados, el salario máximo, salario mínimo,
-- valor total de los salarios y salario promedio.

SELECT
    ee.id_escolaridad AS "CODIGO ESCOLARIDAD",
    ee.desc_escolaridad AS "DESCRIPCION ESCOLARIDAD",
    COUNT(e.run_emp) AS "TOTAL EMPLEADOS",
    TO_CHAR(MAX(e.salario), '$999G999G999') AS "SALARIO MAXIMO",
    TO_CHAR(MIN(e.salario), '$999G999G999') AS "SALARIO MINIMO",
    TO_CHAR(SUM(e.salario), '$999G999G999') AS "VALOR TOTAL SALARIOS",
    TO_CHAR(ROUND(AVG(e.salario), 0), '$999G999G999') AS "SALARIO PROMEDIO"
FROM escolaridad_emp ee
JOIN empleado e ON ee.id_escolaridad = e.id_escolaridad
GROUP BY ee.id_escolaridad, ee.desc_escolaridad
ORDER BY COUNT(e.run_emp) DESC;

-- CASO 5: Sugerencia de Nuevos Ejemplares para Biblioteca
-- Contexto: Informe que muestre la información de los libros
-- con sugerencias de nuevos ejemplares a comprar según las veces
-- que fueron solicitados en préstamo en el último año académico.

SELECT
    t.tituloid AS "CODIGO LIBRO",
    t.titulo AS "TITULO LIBRO",
    c.descripcion AS "CARRERA ASOCIADA",
    COUNT(p.prestamoid) AS "TOTAL VECES SOLICITADO",
    CASE
        WHEN COUNT(p.prestamoid) = 1 THEN 'No se requiere nuevos ejemplares'
        WHEN COUNT(p.prestamoid) BETWEEN 2 AND 3 THEN '1 nuevo ejemplar'
        WHEN COUNT(p.prestamoid) BETWEEN 4 AND 5 THEN '2 nuevos ejemplares'
        WHEN COUNT(p.prestamoid) > 5 THEN '4 nuevos ejemplares'
    END AS "SUGERENCIA NUEVOS EJEMPLARES"
FROM titulo t
JOIN ejemplar ej ON t.tituloid = ej.tituloid
JOIN prestamo p ON ej.tituloid = p.tituloid AND ej.ejemplarid = p.ejemplarid
JOIN alumno a ON p.alumnoid = a.alumnoid
JOIN carrera c ON a.carreraid = c.carreraid
WHERE EXTRACT(YEAR FROM p.fecha_ini_prestamo) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY t.tituloid, t.titulo, c.descripcion
HAVING COUNT(p.prestamoid) > 1
ORDER BY COUNT(p.prestamoid) DESC;

-- CASO 6: Informe de Asignación por Atención de Préstamos
-- Contexto: Informe mensual del pago que se efectuó por conceptos
-- de bonificación a empleados que han atendido más de 2 préstamos.
-- El informe se ejecuta el primer día hábil de cada año, mostrando
-- el detalle de los pagos efectuados el año anterior.

SELECT
    TO_CHAR(p.fecha_ini_prestamo, 'MM/YYYY') AS "MES Y AÑO",
    TO_CHAR(e.run_emp, '09G999G999') || '-' || UPPER(e.dv_run) AS "RUN EMPLEADO",
    INITCAP(e.nombre || ' ' || e.apaterno || ' ' || e.amaterno) AS "NOMBRE COMPLETO",
    COUNT(p.prestamoid) AS "TOTAL PRESTAMOS ATENDIDOS",
    TO_CHAR(COUNT(p.prestamoid) * 10000, '$999G999G999') AS "VALOR ASIGNACION"
FROM prestamo p
JOIN empleado e ON p.run_emp = e.run_emp
WHERE EXTRACT(YEAR FROM p.fecha_ini_prestamo) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY TO_CHAR(p.fecha_ini_prestamo, 'MM/YYYY'), 
         EXTRACT(YEAR FROM p.fecha_ini_prestamo),
         EXTRACT(MONTH FROM p.fecha_ini_prestamo),
         e.run_emp, e.dv_run, e.nombre, e.apaterno, e.amaterno
HAVING COUNT(p.prestamoid) > 2
ORDER BY EXTRACT(YEAR FROM p.fecha_ini_prestamo) ASC,
         EXTRACT(MONTH FROM p.fecha_ini_prestamo) ASC,
         COUNT(p.prestamoid) * 10000 DESC, 
         e.run_emp DESC;
