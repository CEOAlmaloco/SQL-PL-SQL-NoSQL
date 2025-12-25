# CLÍNICA KETEKURA - Casos de Recuperación de Datos

## Base de Datos

**Script de creación y poblado**: `DB/pobla_tablas_ketekura.sql`

---

## CONTEXTO DE NEGOCIO

**Clínica KETEKURA** es una institución de salud privada que ha logrado posicionarse entre las cinco clínicas de salud más importantes del país gracias a la gestión de la nueva Junta Directiva. La clínica gestiona información sobre pacientes, médicos, especialidades, atenciones médicas y pagos.

### Servicios Ofrecidos

La clínica ofrece una amplia gama de servicios médicos:

- Consultas Médicas
- Anatomía Patológica
- Medicina Nuclear
- Banco de Sangre
- Laboratorio
- Imagenología
- Radioterapia
- Centro de Procedimientos de diagnóstico y terapéuticos

### Estructura Organizacional

- **Unidades de Atención**: Diferentes unidades especializadas
- **Especialidades Médicas**: Múltiples especialidades médicas
- **Sistema de Salud**: FONASA, ISAPRE y otros

### Valores y Principios

- Excelencia en la atención médica
- Eficiencia en la gestión de recursos
- Calidad y seguridad en la atención a pacientes
- Mejora continua de procesos
- Apoyo a la comunidad y salud pública

---

## REQUERIMIENTOS A RESOLVER

### CASO 1: Beneficios a Pacientes de Fonasa e Isapres y Tercera Edad

**Contexto del Problema:**

Una de las innovaciones que han marcado la diferencia entre Clínica KETEKURA y el resto de los centros de salud privados del país es el establecer en forma constante una serie de convenios con los pacientes que optan por una atención médica en la clínica. Estos beneficios tienen directa relación con el pago de aranceles preferenciales.

**Requerimiento 1.1: Beneficio a pacientes de Fonasa e Isapres**

Se ha definido aplicar, durante el mes, una rebaja del 20% en el arancel por consulta médica de los pacientes que pertenecen a las entidades de salud (Fonasa e Isapres) que se han efectuado más atenciones médicas que el total de atenciones promedios diarias en el mes anterior.

**Información Requerida:**

- Tipo de salud
- Descripción del tipo de salud
- Total de atenciones efectuadas

**Formato de Salida:**

- Ordenado en forma alfabética por el tipo de salud y su descripción
- El informe se ejecuta el primer día hábil de cada mes

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 1.1

**Requerimiento 1.2: Beneficio a pacientes de la tercera edad**

Para los pacientes que tengan 65 o más años y que durante el año hayan efectuado más de 4 consultas médicas, se les aplica un descuento en el valor de la primera atención médica del siguiente año.

**Información Requerida:**

- RUN del paciente
- Nombre completo del paciente
- Edad del paciente
- Total de atenciones médicas del año
- Porcentaje de descuento (según tabla PORC_DESCTO_3RA_EDAD)
- Año siguiente para el descuento

**Formato de Salida:**

- Ordenado alfabéticamente por el apellido paterno del paciente
- El informe se ejecuta el último día hábil de cada año

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 1.2

---

### CASO 2: Médicos con Especialidades de Baja Demanda

**Contexto del Problema:**

Se evidenció que existían especialidades en las que se existía una sobredemanda de atenciones que no podía ser cubierta con la cantidad de profesionales contratados, así como existen otras especialidades en las que la cantidad de médicos contratados no se justificaba dado la baja cantidad de atenciones médicas que se realizan.

**Requerimiento:**

Crear el cargo de Supervisor de las especialidades médicas en las que anualmente se han efectuado menos de diez atenciones. Se requiere un informe que automáticamente entregue esta información.

**Información Requerida:**

- Nombre de la especialidad
- RUN del médico
- Nombre completo del médico
- Total de atenciones médicas del año anterior

**Formato de Salida:**

- Ordenado alfabéticamente por especialidad y apellido paterno del médico
- El informe se ejecuta el primer día hábil de cada año mostrando información del año anterior

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 2

---

### CASO 3: Médicos para Servicio a la Comunidad

**Contexto del Problema:**

Clínica KETEKURA ha definido una estrategia de apoyo a la comunidad y ofrecerá los servicios de sus profesionales a consultorios y hospitales del área de la Salud Pública. Los médicos que pondrán a disposición serán aquellos que han efectuado menos del máximo de atenciones médicas realizadas por los profesionales durante el año.

**Requerimiento:**

Implementar un informe que en forma automática entregue la información de estos profesionales médicos. La información debe quedar almacenada en la tabla MEDICOS_SERVICIO_COMUNIDAD.

**Información Requerida:**

- Nombre de la unidad
- Nombre completo del médico
- Teléfono del médico
- Correo electrónico institucional (generado según regla)
- Total de atenciones médicas realizadas durante el año

**Regla de Correo Institucional:**

Las dos primeras letras de la unidad + la penúltima y antepenúltima letra de su apellido paterno + los tres últimos números de su teléfono + el día y mes en que fue contratado + @medicocktk.cl

**Formato de Salida:**

- Ordenado alfabéticamente por el nombre de la unidad y apellido paterno del médico
- El informe se ejecuta el primer día hábil de cada año

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 3

---

### CASO 4: Informes para Acreditación en Salud

**Contexto del Problema:**

El proceso de reacreditación en Calidad de Salud le corresponde llevarlo a cabo el próximo año y éste presenta diferencias importantes respecto del proceso anterior. El área que gestiona las atenciones médicas debe proporcionar información relacionada con:

- Informe 1: meses del año en que se han efectuado atenciones médicas igual o mayor al promedio de atenciones médicas mensuales
- Informe 2: Pacientes que han tenido días de morosidad en el pago de su atención médica mayor al promedio de días de morosidad anual

**Requerimiento:**

Ambos informes deben reflejar la historia de los últimos tres años.

**INFORME 1 - Consideraciones:**

- Período de las atenciones médicas (mes y año)
- Total de atenciones médicas realizadas por período
- Monto total de las atenciones médicas realizadas por período

**INFORME 2 - Consideraciones:**

- Regla de Negocio: por cada día de atraso, el paciente debe pagar $2000 de interés
- RUN del paciente
- Nombre completo
- Identificación de la atención
- Fecha de vencimiento del pago
- Fecha de pago
- Días de morosidad
- Valor de la multa

**Formato de Salida:**

- Informe 1: Ordenado por el período de atenciones médicas
- Informe 2: Ordenado por fecha de vencimiento del pago en forma ascendente y por el total de días de morosidad en forma descendente
- Ambos informes se ejecutan el último día hábil del año

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 4

---

### CASO 5: Bonificación por Utilidades para Médicos

**Contexto del Problema:**

De acuerdo con el Convenio Colectivo establecido entre los funcionarios y Clínica KETEKURA, el 30% de las ganancias obtenidas durante el año se deben distribuir entre los funcionarios (excluyendo a los médicos). Para el caso particular de los médicos, sólo el 5% de las ganancias se distribuye entre ellos siempre que hayan superado las siete atenciones médicas durante el año.

**Requerimiento:**

Informe online que permita obtener la información de los médicos a los que les corresponde el pago de esta bonificación. El informe se ejecutará 15 minutos antes del proceso de cálculo de remuneraciones del mes de diciembre.

**Información Requerida:**

- RUN del médico
- Nombre completo del médico
- Total de atenciones médicas del año
- Bonificación por utilidades (5% de las ganancias dividido entre los médicos elegibles)

**Formato de Salida:**

- Ordenado por run y alfabéticamente por el apellido paterno del médico
- El monto de las ganancias acumuladas debe ser ingresado en forma paramétrica

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 5

---

## ARCHIVOS RELACIONADOS

- **Base de Datos**: `DB/pobla_tablas_ketekura.sql`
- **Soluciones SQL**: `SQL/solucion.sql` - Contiene las 5 soluciones SQL completas

---

## NOTAS IMPORTANTES

1. Todas las consultas deben usar funciones de fecha dinámicas (SYSDATE, EXTRACT, ADD_MONTHS, etc.) y NO fechas fijas
2. Los valores paramétricos deben usar variables de sustitución (`&variable`)
3. El formato de salida debe coincidir exactamente con los ejemplos proporcionados
4. Para el CASO 1.2, si el paciente tiene 64 años con 6 o más meses, se considera que tiene 65 años
5. Para el CASO 4, los informes deben reflejar la historia de los últimos tres años
6. Para el CASO 5, las ganancias acumuladas deben ser ingresadas en forma paramétrica

