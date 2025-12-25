-- RENT A HOUSE - SOLUCIONES SQL COMPLETAS
-- Este archivo contiene las soluciones SQL para los 6 casos
-- de la empresa RENT A HOUSE

-- CASO 1: Listado de Cumpleaños de Empleados
-- Contexto: Obtener listado de todos los empleados con fecha 
-- de nacimiento para reservar horas en centros de spa.

SELECT 
    TO_CHAR(e.numrut_emp, '09G999G999') || '-' || UPPER(e.dvrut_emp) AS "RUN EMPLEADO",
    INITCAP(e.nombre_emp || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE COMPLETO",
    TO_CHAR(e.fecnac_emp, 'DD/MM/YYYY') AS "FECHA NACIMIENTO"
FROM empleado e
WHERE e.fecnac_emp IS NOT NULL
ORDER BY e.fecnac_emp ASC, e.appaterno_emp ASC;

-- CASO 2: Informe de Clientes para Estrategia de Marketing
-- Contexto: Informe de clientes solteros, separados o 
-- divorciados para campaña de marketing de departamentos.

SELECT 
    TO_CHAR(c.numrut_cli, '09G999G999') || '-' || UPPER(c.dvrut_cli) AS "RUN CLIENTE",
    INITCAP(c.nombre_cli || ' ' || c.appaterno_cli || ' ' || c.apmaterno_cli) AS "NOMBRE COMPLETO",
    TO_CHAR(c.renta_cli, '$999G999G999') AS "RENTA",
    c.fonofijo_cli AS "TELEFONO FIJO",
    c.celular_cli AS "TELEFONO CELULAR"
FROM cliente c
JOIN estado_civil ec ON c.id_estcivil = ec.id_estcivil
WHERE ec.desc_estcivil IN ('Soltero', 'Separado', 'Divorciado')
AND (ec.desc_estcivil = 'Soltero' OR (ec.desc_estcivil IN ('Separado', 'Divorciado') AND c.renta_cli >= 800000))
ORDER BY c.appaterno_cli ASC, c.apmaterno_cli ASC;

-- CASO 3: Proyección de Bono de Capacitación
-- Contexto: Informe que permita proyectar el gasto del bono 
-- de capacitación (50% del sueldo) para todos los empleados.

SELECT 
    INITCAP(e.nombre_emp || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE COMPLETO",
    TO_CHAR(e.sueldo_emp, '$999G999G999') AS "SUELDO",
    TO_CHAR(e.sueldo_emp * 0.5, '$999G999G999') AS "BONO CAPACITACION"
FROM empleado e
ORDER BY (e.sueldo_emp * 0.5) DESC;

-- CASO 4: Compensación por Error en Reajuste
-- Contexto: Compensación del 5,4% del valor de arriendo 
-- por error en reajuste de propiedades.

SELECT 
    TO_CHAR(p.numrut_prop, '09G999G999') || '-' || UPPER(p.dvrut_prop) AS "RUN PROPIETARIO",
    INITCAP(p.nombre_prop || ' ' || p.appaterno_prop || ' ' || p.apmaterno_prop) AS "NOMBRE PROPIETARIO",
    pr.nro_propiedad AS "NRO PROPIEDAD",
    pr.direccion_propiedad AS "DIRECCION",
    TO_CHAR(pr.valor_arriendo, '$999G999G999') AS "VALOR ARRIENDO",
    TO_CHAR(pr.valor_arriendo * 0.054, '$999G999G999') AS "COMPENSACION"
FROM propietario p
JOIN propiedad pr ON p.numrut_prop = pr.numrut_prop
ORDER BY p.numrut_prop ASC;

-- CASO 5: Proyección de Reajuste Salarial
-- Contexto: Informe automático de reajuste salarial del 13,5% 
-- para todos los empleados.

SELECT 
    TO_CHAR(e.numrut_emp, '09G999G999') || '-' || UPPER(e.dvrut_emp) AS "RUN EMPLEADO",
    INITCAP(e.nombre_emp || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE COMPLETO",
    TO_CHAR(e.sueldo_emp, '$999G999G999') AS "SALARIO ACTUAL",
    TO_CHAR(e.sueldo_emp * 1.135, '$999G999G999') AS "SALARIO AUMENTADO",
    TO_CHAR(e.sueldo_emp * 0.135, '$999G999G999') AS "AUMENTO"
FROM empleado e
ORDER BY (e.sueldo_emp * 0.135) ASC, e.appaterno_emp ASC;

-- CASO 6: Verificación de Cálculo de Remuneraciones
-- Contexto: Comparar valores calculados automáticamente vs 
-- valores correctos de remuneraciones.

SELECT 
    INITCAP(e.nombre_emp || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp) AS "NOMBRE EMPLEADO",
    TO_CHAR(e.sueldo_emp, '$999G999G999') AS "SALARIO",
    TO_CHAR(e.sueldo_emp * 0.055, '$999G999G999') AS "COLACION",
    TO_CHAR(e.sueldo_emp * 0.178, '$999G999G999') AS "MOVILIZACION",
    TO_CHAR(e.sueldo_emp * 0.078, '$999G999G999') AS "DESCUENTO SALUD",
    TO_CHAR(e.sueldo_emp * 0.065, '$999G999G999') AS "DESCUENTO AFP",
    TO_CHAR(
        e.sueldo_emp + 
        (e.sueldo_emp * 0.055) + 
        (e.sueldo_emp * 0.178) - 
        (e.sueldo_emp * 0.078) - 
        (e.sueldo_emp * 0.065), 
        '$999G999G999'
    ) AS "ALCANCE LIQUIDO"
FROM empleado e
ORDER BY e.appaterno_emp ASC;
