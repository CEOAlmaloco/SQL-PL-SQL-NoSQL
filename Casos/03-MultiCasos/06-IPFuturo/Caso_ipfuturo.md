# IPFUTURO (TUFUTURO) - Casos de Recuperación de Datos

## Base de Datos

**Script de creación y poblado**: `DB/pobla_tablas_ipfuturo.sql`

---

## CONTEXTO DE NEGOCIO

**TUFUTURO** es un instituto profesional que requiere gestionar información de manera eficiente para las diferentes áreas de la institución: Finanzas, Recursos Humanos, Matrículas de Alumnos y Biblioteca (préstamos y devoluciones de libros).

### Áreas de Gestión

El instituto profesional TUFUTURO requiere automatizar los procesos que generan el presupuesto e informes económicos para garantizar la disponibilidad, calidad y seguridad de la información que se requiere para la gestión del IP, evitando así:

- Lentitud en los procesos
- Contar con información errónea
- No contar con la información de manera oportuna
- Manipulación manual de los datos

### Principios y Valores

La formación de profesionales responsables, competentes y comprometidos está basada en los principios y valores que son la impronta de TUFUTURO:

- La educación como poder transformador de los alumnos
- Calidad Académica
- El estudiante como eje del IP
- Inclusión
- Mejora continua de los procesos
- Innovación
- Efectividad
- Integridad
- Actitud de servicio

---

## REQUERIMIENTOS A RESOLVER

### CASO 1: Presupuesto de Publicidad por Carrera

**Contexto del Problema:**

En el mes de octubre, se reúnen los encargados del área Finanzas para elaborar una proyección del presupuesto del año siguiente. En esta proyección se considera la información real de los gastos, pérdidas y ganancias monetarias que el IP tuvo en el último año (octubre del año anterior a septiembre del presente año).

Entre los ítems considerados como gastos en el presupuesto, están los dineros que TUFUTURO invertirá en estrategias publicitarias para promocionar las carreras que se imparten en cada sede. La política definida para efectuar la asignación de los dineros a cada Escuela corresponde a un monto por cada alumno matriculado en las carreras que se imparten. Este monto se reajusta anualmente, de acuerdo con el IPC anual, por lo tanto, es un monto variable.

**Requerimiento:**

Informe que muestre la asignación de presupuesto de publicidad por carrera considerando:

- El monto por concepto de publicidad asignado por alumno matriculado debe ser ingresado en forma paramétrica al informe
- La información se debe visualizar ordenada en forma descendente por el total de alumnos matriculados y la identificación de la carrera

**Información Requerida:**

- Identificación de la carrera
- Nombre de la carrera
- Total de alumnos matriculados
- Monto por alumno (paramétrico)
- Total presupuesto publicidad (total alumnos × monto por alumno)

**Formato de Salida:**

- Ordenado en forma descendente por el total de alumnos matriculados
- Ordenado por la identificación de la carrera

**Solución SQL:** Ver `SQL/soluciones_basicas.sql` - CASO 1

**Prueba:** Ejecutar con valor de $30.200 por concepto de publicidad asignado por alumno.

---

### CASO 2: Beneficio para Carreras con Más de 4 Alumnos

**Contexto del Problema:**

La rectoría de TUFUTURO ha definido una serie de políticas de mejoras continuas en el proceso de aprendizaje de sus alumnos. Una de ellas considera entregar todos los años, en el mes de mayo, un beneficio en dinero a las carreras que se imparte en el IP que poseen más de cuatro alumnos matriculados con el objetivo que de que se invierta en mejorar y actualizar la tecnología (hardware y software) que requieren.

**Requerimiento:**

Proceso programado en la base de datos que, el segundo domingo del mes de abril, genere automáticamente la información de las carreras con más de cuatro alumnos matriculados.

**Información Requerida:**

- Identificación de la carrera
- Nombre de la carrera
- Total de alumnos matriculados

**Formato de Salida:**

- Ordenado por la identificación de la carrera
- Solo carreras con más de 4 alumnos matriculados

**Solución SQL:** Ver `SQL/soluciones_basicas.sql` - CASO 2

---

### CASO 3: Bonificación para Jefes

**Contexto del Problema:**

Preocupados siempre por el bienestar de sus empleados, en diciembre de cada año, a todos los empleados que trabajan en TUFUTURO se les pagan algunas bonificaciones especiales de acuerdo con los criterios definidos por la Rectoría.

Para el caso de los empleados que son jefes, se les paga una asignación anual cuyo monto está asociado al salario máximo del empleado del cual es jefe y el número total de empleados a su cargo. Así por ejemplo si el jefe posee 5 empleados a su cargo la bonificación que le corresponderá será el 50% del salario máximo entre sus 5 empleados, si el jefe posee 3 empleados su bonificación corresponderá al 30% del salario máximo entre los 3 empleados a su cargo, etc.

**Requerimiento:**

Informe que muestre los jefes que serán beneficiados con este bono especial.

**Información Requerida:**

- RUN del jefe
- Nombre completo del jefe
- Total de empleados a cargo
- Salario máximo entre sus empleados
- Porcentaje de bonificación (total empleados × 10%)
- Monto de la bonificación

**Formato de Salida:**

- Ordenado en forma ascendente por el total de empleados a cargo de cada jefe

**Solución SQL:** Ver `SQL/soluciones_basicas.sql` - CASO 3

---

### CASO 4: Informe de Salarios por Nivel de Escolaridad para CNA

**Contexto del Problema:**

El próximo año, TUFUTURO deberá volver a someterse al proceso de acreditación institucional y la CNA ha enviado el listado de los nuevos informes que las instituciones deben presentar. Uno de estos nuevos informes económicos obligatorios que las instituciones deben presentar al CNA es un resumen de pagos de salarios por nivel de escolaridad de los empleados.

**Requerimiento:**

Informe que muestre un resumen, por nivel de escolaridad, que especifique el total de empleados, el salario máximo, salario mínimo, valor total de los salarios y salario promedio.

**Códigos de Escolaridad:**

- 10: BÁSICA
- 20: MEDIA CIENTÍFICA HUMANISTA
- 30: MEDIA TÉCNICO PROFESIONAL
- 40: SUPERIOR CENTRO DE FORMACIÓN TECNICA
- 50: SUPERIOR INSTITUTO PROFESIONAL
- 60: SUPERIOR UNIVERSIDAD

**Información Requerida:**

- Código de escolaridad
- Descripción del nivel de escolaridad
- Total de empleados
- Salario máximo
- Salario mínimo
- Valor total de los salarios
- Salario promedio

**Formato de Salida:**

- Ordenado en forma descendente por total de empleados
- Valores redondeados

**Solución SQL:** Ver `SQL/soluciones_basicas.sql` - CASO 4

---

### CASO 5: Sugerencia de Nuevos Ejemplares para Biblioteca

**Contexto del Problema:**

En la proyección del presupuesto anual que debe elaborar el área Finanzas, otro de los gastos que se debe considerar corresponde a la compra de libros que la biblioteca del IP debe realizar cada año.

En la etapa 1, la Biblioteca del IP, además de enviar el catastro de libros actualizados a cada Director(a) de Carrera, tendrá que adjuntar, como apoyo, una propuesta de los libros con la cantidad de nuevos ejemplares que se deberían considerar comprar según las veces que fueron solicitado en préstamo en el último año académico finalizado.

**Criterios de Sugerencia:**

| Solicitudes en Préstamo (Últimos 12 meses) | Sugerencia de Nuevos Ejemplares |
|---------------------------------------------|--------------------------------|
| Una vez | No se requiere nuevos ejemplares |
| Entre dos y tres veces | Se requiere comprar 1 nuevo ejemplar |
| Entre cuatro y cinco veces | Se requiere comprar 2 nuevos ejemplares |
| Más de cinco veces | Se requiere comprar 4 nuevos ejemplares |

**Requerimiento:**

Informe que muestre la información de los libros con sugerencias de nuevos ejemplares a comprar. El informe debe ser capaz de obtener la información del año anterior a la fecha en que se ejecute en forma automática.

**Información Requerida:**

- Código del libro
- Título del libro
- Carrera asociada
- Total de veces solicitado en préstamo (año anterior)
- Sugerencia de nuevos ejemplares a comprar

**Formato de Salida:**

- Ordenado en forma descendente por total de veces que se solicitó en préstamo

**Solución SQL:** Ver `SQL/soluciones_basicas.sql` - CASO 5

---

### CASO 6: Informe de Asignación por Atención de Préstamos

**Contexto del Problema:**

El resultado de las encuestas de los alumnos, hicieron que en marzo de este año se renovara al personal que tiene a su cargo la atención de préstamos de libros en la biblioteca del IP. Este cambio mejoró en forma significativa la atención a los alumnos.

Debido a esto, la Rectoría del IP decidió que mensualmente a los empleados que han atendido más de 2 préstamos se les pague una asignación que corresponde a $10.000 por cada préstamo atendido durante el mes.

**Requerimiento:**

Informe mensual del pago que se efectuó por conceptos de esta nueva bonificación. Este informe se ejecutará el primer día hábil de cada año, mostrando el detalle de los pagos efectuados el año anterior.

**Información Requerida:**

- Mes y año del préstamo
- RUN del empleado
- Nombre completo del empleado
- Total de préstamos atendidos
- Valor asignación por atención de préstamos ($10.000 × total préstamos)

**Formato de Salida:**

- Ordenado en forma ascendente por la fecha (mes y año) del préstamo
- Ordenado en forma descendente por el valor de la asignación por atención de préstamos
- Ordenado en forma descendente por el run del empleado

**Solución SQL:** Ver `SQL/soluciones_basicas.sql` - CASO 6

---

## ARCHIVOS RELACIONADOS

- **Base de Datos**: `DB/pobla_tablas_ipfuturo.sql`
- **Soluciones SQL**: `SQL/solucion.sql` - Contiene las 6 soluciones SQL completas

---

## NOTAS IMPORTANTES

1. Todas las consultas deben usar funciones de fecha dinámicas (SYSDATE, EXTRACT, etc.) y NO fechas fijas
2. Los valores paramétricos deben usar variables de sustitución (`&variable`)
3. El formato de salida debe coincidir exactamente con los ejemplos proporcionados
4. Las consultas deben estar optimizadas y usar los índices apropiados cuando sea necesario
5. Para el CASO 5, el año anterior se calcula como `EXTRACT(YEAR FROM SYSDATE) - 1`
6. Para el CASO 6, el informe se ejecuta el primer día hábil del año mostrando información del año anterior

