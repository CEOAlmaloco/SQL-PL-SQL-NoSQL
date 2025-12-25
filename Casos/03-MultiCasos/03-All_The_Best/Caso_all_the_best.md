# ALL THE BEST - Casos de Recuperación de Datos

## Base de Datos

**Script de creación y poblado**: `DB/pobla_tablas_all_the_best.sql`

---

## CONTEXTO DE NEGOCIO

**ALL THE BEST** es una empresa de retail que ha experimentado un crecimiento significativo desde su creación. La empresa se caracteriza por ofrecer servicios financieros innovadores a través de la tarjeta CATB (tarjeta de crédito de la empresa), permitiendo a los clientes realizar compras, avances y súper avances en dinero con tasas de interés más atractivas que las ofrecidas por otras empresas del mismo rubro y entidades bancarias tradicionales.

### Estrategias de Negocio

- **Programa de Puntos CIRCULO ALL THE BEST**: Implementado desde enero del año pasado, entrega beneficios a clientes que usan la tarjeta CATB. Los puntos se acumulan al RUN del cliente.
- **Categorización de Clientes**: Los clientes se categorizan según el monto total de compras, avances y súper avances realizados con la tarjeta CATB: PLATINUM, GOLD, SILVER, PLATA, BRONCE, SIN CATEGORIZACION.
- **Gestión de Sucursales**: La empresa tiene múltiples sucursales distribuidas en diferentes regiones del país.

### Productos y Servicios

- **Tarjeta CATB**: Permite compras, avances en efectivo y súper avances
- **Programa de Puntos**: Por cada $10.000 del monto (sin considerar tasa de interés) = 250 puntos
- **Vigencia de Puntos**: 36 meses
- **Mínimo para Canjear**: 5.000 puntos

### Valores Corporativos

- Máxima eficiencia en todas las áreas
- Información actualizada en tiempo real
- Automatización de procesos
- Excelencia en la gestión del negocio

---

## REQUERIMIENTOS A RESOLVER

### CASO 1: Clientes de Cumpleaños del Mes Siguiente

**Contexto del Problema:**

Como parte de las estrategias de marketing que ALL THE BEST ha definido desde su creación, el mantener un contacto permanente con sus clientes ha sido de vital importancia para su crecimiento. El área de servicio al cliente de la casa matriz (Santiago) tiene entre sus tareas contactarse telefónicamente con los clientes para saludarlos el día de su cumpleaños.

Actualmente este trabajo se realiza de manera centralizada y depende de una aplicación externa que actualiza la información una vez a la semana. Para mejorar la eficiencia, se requiere:

- Que la información se obtenga directamente desde la base de datos del Sistema de Captación de Clientes
- No centralizar las tareas rutinarias que se pueden realizar en cada sucursal
- No depender de la disponibilidad del personal de la casa matriz

**Requerimiento:**

Generar un proceso automático que mensualmente genere la información requerida y la envíe a los correos de los jefes del área de atención de clientes de cada sucursal. El proceso debe:

- Entregar información de clientes que estarán de cumpleaños en el mes siguiente al que se ejecute el proceso
- Ser capaz de obtener la información de la sucursal que se ingrese en forma paramétrica

**Información Requerida:**

- Identificación de la sucursal
- Región de la sucursal
- RUN del cliente
- Nombre completo del cliente
- Día de cumpleaños

**Formato de Salida:**

- Ordenado en forma ascendente por el día de cumpleaños de los clientes
- Alfabéticamente por su apellido paterno

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 1

---

### CASO 2: Informe de Transacciones y Puntos para SBIF

**Contexto del Problema:**

La SBIF ha dispuesto que, a contar de este año, las empresas de retail deben informar todas las transacciones que sus clientes han realizado usando la tarjeta de la empresa y los puntos acumulados.

**Requerimiento:**

El Sistema debe proveer a la SBIF de la información de todas las compras, avances y súper avances que se realizaron durante el año anterior. El informe requerido se debe enviar la primera semana de enero de cada año.

**Información Requerida:**

- RUN del cliente
- Nombre completo
- Monto total por compras
- Monto total por avances en efectivo
- Monto total por súper avances
- Total de puntos acumulados por todas las transacciones realizadas con la tarjeta CATB en el año

**Formato de Salida:**

- Ordenado en forma ascendente por el total de puntos del programa CIRCULO ALL THE BEST
- Alfabéticamente por el apellido paterno del cliente

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 2

---

### CASO 3: Informe de Avances y Súper Avances para SBIF

**Contexto del Problema:**

A contar de enero del próximo año entrará en vigencia la Ley de Operaciones de Avances y Súper Avances en dinero que obliga a todas las empresas de retail a aportar un porcentaje de las ganancias de los Avances y Súper Avances para la implementación de proyectos de formación de capital humano.

**Requerimiento:**

Generar automáticamente toda la información requerida por la SBIF. La información se debe enviar el primer día hábil del mes de enero y debe permitir saber, por cada mes del año anterior:

- Tipo de transacción (Avance o Súper Avance)
- Monto total por el tipo de transacción
- Monto total que la empresa aporta al SBIF por ese tipo de transacción

**Reglas de Negocio:**

- Los avances y súper avances en dinero no pueden ser anulados por los clientes
- El aporte a la SBIF está basado en el monto total de la transacción (con la tasa de interés aplicada)
- El valor del aporte se define según la tabla APORTE_SBIF

**Formato de Salida:**

- Ordenado en forma ascendente por mes y nombre del crédito

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 3

---

### CASO 4: Categorización de Clientes por Monto Total

**Contexto del Problema:**

Para obtener la certificación ISO 9001 es obligatorio que todos los procesos de gestión del negocio estén automatizados. Actualmente, la información de clientes categorizados se maneja a través de planillas Excel.

**Requerimiento:**

Diseñar y automatizar el proceso que genere anualmente la información de los clientes categorizados de acuerdo con el monto total de las compras, avances y súper avances que han realizado con su tarjeta CATB.

**Reglas de Negocio:**

- A un cliente se le pueden entregar un máximo de 3 tarjetas adicionales
- Para más de una tarjeta adicional, el cliente debe poseer un salario líquido mensual igual o superior a $2.000.000
- Cada tarjeta tiene una numeración diferente

**Categorización:**

| MONTO TOTAL COMPRAS/AVANCES/SUPER AVANCES | CATEGORIZACIÓN DEL CLIENTE |
|-------------------------------------------|---------------------------|
| Entre $0 y $100.001 | SIN CATEGORIZACION |
| Entre $100.000 y $1.000.000 | BRONCE |
| Entre $1.000.001 y $4.000.000 | PLATA |
| Entre $4.000.001 y $8.000.000 | SILVER |
| Entre $8.000.001 y $15.000.000 | GOLD |
| Mayor a $15.000.000 | PLATINUM |

**Formato de Salida:**

- Ordenado alfabéticamente por el apellido paterno del cliente
- En forma descendente por monto total ahorrado

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 4

---

### CASO 5: Informe Resumen de Súper Avances para SII

**Contexto del Problema:**

Las empresas de retail deben proporcionar al SII la información de los clientes que poseen súper avances ya que financieramente tienen el mismo trato como si fueran un crédito asociado a la renta.

**Requerimiento:**

Generar un informe resumen que contenga el resumen por cada cliente de la cantidad de súper avances en efectivo vigentes que posee y el monto totalizado de esos avances (valor sin la tasa de interés aplicada). El informe se debe enviar al SII la primera semana de marzo.

**Información Requerida:**

- Año tributario (corresponde al año siguiente en que se ejecutó el informe)
- RUN del cliente
- Nombre completo del cliente
- Cantidad total de súper avances vigentes
- Monto total por todos los súper avances vigentes que posee

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno del cliente
- El informe se ejecuta el último día hábil del año

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 5

---

### CASO 6: Informes de Balance para SBIF

**Contexto del Problema:**

Las nuevas exigencias de Transparencia definidas por la SBIF obligan que todas las empresas de retail informen sus activos del balance anual. La información debe estar disponible en la plataforma web de la empresa siguiendo los estándares de las normas ISO 27001 e ISO 27002.

**Requerimiento:**

Desarrollar dos informes obligatorios (prioridad 1):

**INFORME 1**: Detalle de todos los clientes que poseen tarjeta CATB considerando:
- Identificación de la sucursal en la que el cliente solicitó la tarjeta
- Región de la sucursal
- RUN del cliente
- Nombre del cliente
- Cantidad de compras vigentes a la fecha de ejecutar el informe
- Valor total de las compras vigentes
- Cantidad de avances en efectivo vigentes
- Valor total de los avances en efectivo vigentes
- Cantidad de súper avances en efectivo vigentes
- Valor total de los súper avances en efectivo vigentes

**INFORME 2**: Resumen por sucursal de las transacciones realizadas por los clientes usando la tarjeta CATB considerando:
- Región de la sucursal
- Dirección de la sucursal
- Cantidad y valor total de compras vigentes
- Cantidad y valor total de avances en efectivo vigentes
- Cantidad y valor total de súper avances en efectivo vigentes

**Reglas de Negocio:**

- Se considera vigente una compra, avance o súper cuando aún posee cuota(s) por pagar
- El año debe ser ingresado en forma paramétrica

**Formato de Salida:**

- Ordenado alfabéticamente por el nombre de la región
- En forma ascendente por la identificación de la sucursal
- Alfabéticamente por el apellido paterno del cliente

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 6

---

## ARCHIVOS RELACIONADOS

- **Base de Datos**: `DB/pobla_tablas_all_the_best.sql`
- **Soluciones SQL**: `SQL/solucion.sql` - Contiene las 6 soluciones SQL completas

---

## NOTAS IMPORTANTES

1. Todas las consultas deben usar funciones de fecha dinámicas (SYSDATE, ADD_MONTHS, EXTRACT, etc.) y NO fechas fijas
2. Los valores paramétricos deben usar variables de sustitución (`&variable`)
3. El formato de salida debe coincidir exactamente con los ejemplos proporcionados
4. Las consultas deben estar optimizadas y usar los índices apropiados cuando sea necesario
5. Para el CASO 1, la sucursal debe ser ingresada en forma paramétrica
6. Para el CASO 6, el año debe ser ingresado en forma paramétrica

