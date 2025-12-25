# RENT A HOUSE - Casos de Recuperación de Datos

## Base de Datos

**Script de creación y poblado**: `DB/pobla_tablas_rent_a_house.sql`

---

## CONTEXTO DE NEGOCIO

El mercado inmobiliario está en constante crecimiento, situación que permite la existencia de clientes no atendidos. En este contexto, existe la necesidad de ciertos clientes de dar en arriendo una propiedad y por otra parte existen clientes que desean poder arrendar una propiedad de acuerdo a sus necesidades y disponibilidad económica. La base de la oportunidad de negocios existente en este rubro es hacer de nexo entre estos dos clientes y satisfacer ambas necesidades a la vez.

Bajo este concepto, hace 5 años **RENT A HOUSE** se incorporó al mercado inmobiliario de la región metropolitana con el objetivo de entregar una solución de calidad en el rubro de arriendo de propiedades nuevas y usadas.

### Estrategias de Negocio

Son tres las formas en la que la empresa concreta su estrategia de negocio:

1. **Colocar en arriendo propiedades** que los clientes deseen ofrecer al mercado.
2. **Tener un arrendador con una necesidad importante**, saber su disposición a pagar, encontrar la propiedad, arrendarla y subarrendársela.
3. **Detectar propiedades con potencial**, que no estén aptas para arriendo, tomarla en arriendo a un precio favorable, sanearlas y subarrendarlas.

### Tipos de Inmuebles

En cualquiera de las opciones, RENT A HOUSE se centra en el arriendo de los siguientes inmuebles:

- Casas amobladas
- Casas sin amoblar
- Departamentos amoblados
- Departamentos sin amoblar
- Locales comerciales sin amoblar
- Parcelas con y sin casas
- Sitios

### Valores Corporativos

La propuesta de valor de la Corredora de propiedades está determinada por los siguientes valores:

- **Cercanía**
- **Confianza**
- **Transparencia**

### Desafíos Futuros

Como desafíos para los próximos años se ha planteado apoyar en:

- Asesoría inmobiliaria y Técnica
- Gestión Legal

---

## REQUERIMIENTOS A RESOLVER

### CASO 1: Listado de Cumpleaños de Empleados

**Contexto del Problema:**

La Corredora de propiedades, consciente que su éxito en el mercado se debe en gran medida al trabajo profesional que sus empleados desempeñan, mensualmente festejará el cumpleaños de sus empleados invitándolos en forma gratuita a un día de spa para que disfruten de un descanso merecido.

**Requerimiento:**

Para esto, el último día hábil de cada año se debe obtener el listado de todos los empleados con la fecha en que nacieron y así poder efectuar con anticipación la reserva de horas en los centros de spa con los que RENT A HOUSE tiene convenios.

**Información Requerida:**

- RUN del empleado
- Nombre completo del empleado
- Fecha de nacimiento

**Formato de Salida:**

- Ordenado en forma ascendente por la fecha de nacimiento del empleado
- Alfabéticamente por su apellido paterno

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 1

---

### CASO 2: Informe de Clientes para Estrategia de Marketing

**Contexto del Problema:**

Estratégicamente, la Corredora de Propiedades ha firmado un convenio con la inmobiliaria UN SUEÑO para hacerse cargo del arriendo de algunos de sus departamentos y lofts de un ambiente. Por esta razón, la Gerencia desea enfocar una nueva estrategia de marketing para ofrecerlos a sus clientes como nuevas opciones de propiedades que se adapten a sus necesidades.

Esta nueva estrategia de negocio es de gran importancia para la Corredora de Propiedades ya que el éxito de esta forma a arrendar departamentos nuevos significaría que otras empresas inmobiliarias podrían establecer alianzas de arriendo y ventas de propiedades con RENT A HOUSE ampliando así el ámbito de su negocio.

**Requerimiento:**

Se requiere de un informe que muestre el run, nombre completo, renta, teléfono fijo y celular de todos los clientes que a la fecha posee la Corredora de Propiedades. Los clientes deben ser solteros, separados o divorciados. Los clientes separados/divorciados deben tener renta >= monto mínimo definido paramétricamente.

**Información Requerida:**

- RUN del cliente
- Nombre completo del cliente
- Renta del cliente
- Teléfono fijo
- Teléfono celular

**Formato de Salida:**

- Ordenado alfabéticamente por el apellido paterno y materno del cliente

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 2

---

### CASO 3: Proyección de Bono de Capacitación

**Contexto del Problema:**

La búsqueda de nuevas e innovadoras estrategias de capacitaciones para sus empleados han hecho que cada uno de ellos, en los diferentes cargos que se desempeñan, aporten a que la Corredora de Propiedades se transforme en una de las empresas líder del rubro. Es por esta razón que el año pasado la Gerencia decidió incorporar como parte del presupuesto anual de la empresa el gasto fijo por concepto de capacitaciones.

Como un incentivo extra, la Gerencia ha dispuesto además que en el mes de diciembre se pague un bono extra a todos los empleados que durante el año efectuaron alguna capacitación que le haya otorgado un valor agregado al trabajo que desempeñan en RENT A HOUSE.

**Requerimiento:**

Se desea contar con un informe que permita saber con antelación cuánto implicaría para la empresa el pago de este incentivo de acuerdo con lo siguiente:

- El informe debe considerar a todos los empleados ya que la idea es poder proyectar el gasto "asumiendo" que todos los empleados, a lo menos una vez al año, asistirán a alguna capacitación.
- El monto del bono corresponderá al 50% de su sueldo.
- Se requiere saber el nombre completo del empleado, el sueldo que posee y el valor del bono que le correspondería.

**Información Requerida:**

- Nombre completo del empleado
- Sueldo actual
- Valor del bono de capacitación (50% del sueldo)

**Formato de Salida:**

- Ordenado en forma descendente por el valor del bono de capacitación

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 3

---

### CASO 4: Compensación por Error en Reajuste

**Contexto del Problema:**

Por un error de datos, el proceso que anualmente reajusta el valor de arriendo de las propiedades que RENT A HOUSE tiene a su cargo aumentó en 5,4% el valor de cada propiedad, pero en realidad el reajuste correspondía a 4,5%. Aunque este error fue corregido, esta situación provocó que los clientes que poseen propiedades en arriendo en la Corredora de Propiedades hayan mostrado su molestia colocando en duda la gestión del arriendo de sus propiedades.

**Requerimiento:**

La Gerencia preocupada de aclarar esta situación, desea citarlos a una junta para poder explicar lo ocurrido y resolver el problema que esto produjo garantizando así la excelencia en el servicio que la Corredora de Propiedades presta. Además, se ha definido pagarles una compensación la que corresponderá al 5,4% del valor del arriendo de cada propiedad que poseen.

**Información Requerida:**

- RUN del propietario
- Nombre completo del propietario
- Número de propiedad
- Dirección de la propiedad
- Valor del arriendo
- Valor de la compensación (5,4% del valor del arriendo)

**Formato de Salida:**

- Ordenado en forma ascendente por run del propietario

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 4

---

### CASO 5: Proyección de Reajuste Salarial

**Contexto del Problema:**

Hasta el año pasado, la forma de reajustar los salarios de los empleados tenía relación directa como los años que el empleado llevaba trabajando en la Corredora de Propiedades. Sin embargo, considerando que el reajuste salarial tiene relación directa con las ganancias que la empresa ha obtenido durante el año, es que la Gerencia ha definido lo siguiente:

- Se va a incorporar un nuevo beneficio extra que estará relacionado con los años que el empleado lleva trabajando en la empresa. Este nuevo beneficio será un bono por antigüedad no imponible.
- A todos los empleados, sin consideraciones especiales, se les reajustará el sueldo en 13,5%.

**Requerimiento:**

Hasta ahora, toda la información por concepto de gasto en reajustes salariales se obtiene a través de una planilla en Excel que genera la persona encargada del área de finanzas y que debe presentar a la Gerencia de corredora de propiedades. Sin embargo, a contar de este año se desea que esta información pueda ser consultada a través de un informe que muestre automáticamente esta información.

**Información Requerida:**

- RUN del empleado
- Nombre completo del empleado
- Salario actual
- Salario aumentado (con 13,5% de aumento)
- Monto del aumento

**Formato de Salida:**

- Ordenado en forma ascendente por el aumento del salario
- Alfabéticamente por el apellido paterno del empleado

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 5

---

### CASO 6: Verificación de Cálculo de Remuneraciones

**Contexto del Problema:**

Por un error informático, este mes, las remuneraciones de los empleados fueron mal calculadas. Si bien el pago de los sueldos ya se efectuó, este error se debe corregir tratando de no perjudicar a los empleados, por lo que el valor que se les pagó de más les descontará en seis cuotas.

**Requerimiento:**

Para que este proceso sea confiable, la Gerencia desea comparar por cada empleado los valores calculados por el proceso automático de cálculo de remuneraciones versus lo que efectivamente debería haber sido calculado.

**Información Requerida:**

- Nombre y apellido del empleado
- Salario
- Colación: 5,5% del salario
- Movilización: 17,8% del salario
- Descuento Salud: 7,8% del salario
- Descuento AFP: 6,5% del salario
- Alcance Líquido: Salario + Colación + Movilización - Descuento Salud - Descuento AFP

**Formato de Salida:**

- Ordenado en forma ascendente por apellido

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 6

---

### CASO 7: Resumen de Propiedades para SII

**Contexto del Problema:**

La Gerencia requiere generar un resumen de todas las propiedades entregadas para arriendo o venta agrupadas por tipo de propiedad para enviar al Servicio de Impuestos Internos (SII).

**Requerimiento:**

Generar resumen de todas las propiedades entregadas para arriendo o venta agrupadas por tipo de propiedad.

**Información Requerida:**

- Número de propiedad
- Dirección de la propiedad
- Comuna
- Propietario
- Fecha de ingreso

**Formato de Salida:**

- Ordenado por tipo de propiedad y número de propiedad

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 7

---

## NOTAS IMPORTANTES

1. Todas las consultas deben usar funciones de fecha dinámicas (SYSDATE, EXTRACT, etc.) y NO fechas fijas
2. Los valores paramétricos deben usar variables de sustitución (`&variable`) o variables BIND en PL/SQL
3. El formato de salida debe coincidir exactamente con los ejemplos proporcionados
4. Las consultas deben estar optimizadas y usar los índices apropiados cuando sea necesario
5. Para casos PL/SQL, usar bloques anónimos con DECLARE, BEGIN, END y manejo de excepciones