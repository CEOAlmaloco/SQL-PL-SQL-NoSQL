# TRUCK RENTAL - Casos de Recuperación de Datos

## Base de Datos

**Script de creación y poblado**: `DB/pobla_tablas_truck_rental.sql`

---

## CONTEXTO DE NEGOCIO

En las últimas 3 décadas, el servicio de arriendo de camiones y maquinarias para la Construcción, Minería y transporte en general ha presentado un sostenido incremento en Chile.

Para satisfacer las necesidades de este rubro, en el año 2017 un grupo de inversionistas crea la empresa **TRUCK RENTAL** para entregar la mejor calidad de servicios, confianza y seguridad al cliente marcando la diferencia en el mercado de la región Metropolitana. Su propósito es proveer de un servicio de excelencia en arriendo de vehículos para todo tipo de empresa y persona particular con el objetivo de mantener una relación a largo plazo con sus clientes basadas en la confianza, la transparencia y la calidad respaldado por un equipo humano altamente calificado.

### Categorización de Clientes

Para el área de arriendos, la empresa ha definido que cada camión es de responsabilidad de un empleado. Cada uno de ellos tiene como labor apoyar todo el proceso de arriendo entregando al cliente un servicio de excelencia. De acuerdo con las políticas internas de TRUCK RENTAL existen cuatro tipos de categorización de los clientes:

- **Socio**: Cliente que requiere de los servicios de la empresa a gran escala de inversión y que además es parte del grupo de accionistas de la empresa.
- **VIP**: Cliente que requiere de los servicios de la empresa a gran escala de inversión y en forma permanente.
- **Nacional**: Cliente que requiere en forma esporádica los servicios de la empresa para alguna empresa o persona natural chilena o extranjera. Es el intermediario entre TRUCK RENTAL y la empresa o persona natural chilena o extranjera.
- **Extranjero**: Cliente que requiere en forma esporádica los servicios de la empresa para alguna empresa o persona natural extrajera. Es el intermediario entre TRUCK RENTAL y la empresa o persona natural extrajera.

### Sistema de Cobros

El cobro por concepto de arriendo es diario y el valor lo establece la empresa de acuerdo al modelo y año del camión. El cliente además debe pagar una garantía (que también se cobra por día de arriendo) dinero que se le reintegra una vez que los ingenieros mecánicos de TRUCK RENTAL dan la aprobación de la devolución del camión arrendado.

El cobro completo o parcial de la garantía de arriendo se puede hacer efectivo por las siguientes razones:

- Que el informe técnico de los ingenieros mecánicos indique que el vehículo posee alguna falla técnica.
- Que el informe técnico de los ingenieros mecánicos indique que el vehículo posee alguna falla de estructura producto de algún incidente (choque, maniobra indebida, etc.).
- Que durante el periodo arrendado le hayan cursado un parte policial o municipal.

### Visión Empresarial

TRUCK RENTAL se proyecta como una empresa líder en el rubro, con una amplia red de contactos, clientes y proveedores, reconocida como una empresa seria, profesional y con capacidad de reacción. Su visión de empresa tiene directa relación con sus valores corporativos y la excelencia en sus servicios, siendo proactivos y visionarios respecto de las necesidades e innovaciones que el mercado necesita.

---

## REQUERIMIENTOS A RESOLVER

### CASO 1: Clientes de Cumpleaños del Día Siguiente

**Contexto del Problema:**

Como parte de las estrategias de marketing que TRUCK RENTAL ha definido para su negocio, el mantener un contacto permanente con sus clientes ha sido de vital importancia para su crecimiento y así marcar la diferencia con otras empresas del rubro de arriendo de camiones haciendo sentir al cliente que no sólo es importante para la empresa en términos monetarios, sino que también en lo personal.

Por esa razón, el área de atención a clientes tiene entre sus tareas contactarse telefónicamente con todos los clientes para saludarlos el día de su cumpleaños. Hasta ahora, este trabajo se efectúa de acuerdo al registro manual que las secretarias tienen de los clientes y por consecuencia, también depende de ellas entreguen envíen la información al área de atención a clientes.

**Requerimiento:**

Se ha pensado que una de las alternativas es enviar un correo todos los días a las 17:00 h. a los encargados del área de atención a clientes detallando los clientes que estarán de cumpleaños el día siguiente y de esta forma ellos puedan contar con la información que requieren en forma anticipada sin tener que depender de la disponibilidad de tiempo que las secretarias tengan y mejorando considerablemente la labor del área de atención al cliente.

**Información Requerida:**

- RUN del cliente
- Nombre completo del cliente
- Fecha de nacimiento

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno
- La sentencia SQL debe entregar la información de los clientes que estarán de cumpleaños el día siguiente en que se ejecute el proceso automático

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 1

---

### CASO 2: Aumento de Movilización por Sueldo Base

**Contexto del Problema:**

Anualmente, por ley, se debe reajustar el valor de movilización que se les paga a los empleados de cualquier empresa. El porcentaje de aumento lo define cada empleador, pero no puede ser menor al de años anteriores.

En el caso de TRUCK RENTAL, por acuerdo entre la Gerencia y los empleados, el porcentaje de aumento anual por concepto de movilización corresponde por cada $100.000 del sueldo base de cada empleado, es decir si el salario del empleado es $350.000 el porcentaje de aumento de movilización será de 3%, si el sueldo base del empleado es de $2.750.000 será de 27%, etc.

**Requerimiento:**

La nueva aplicación que apoyará la gestión del negocio debe considerar un informe online que permita al área de finanzas poder obtener el detalle del aumento en el valor de la movilización mensual que se le debe pagar a cada empleado.

**Información Requerida:**

- RUN del empleado
- Nombre completo del empleado
- Sueldo base
- Porcentaje de movilización (calculado: sueldo_base / 100000)
- Valor actual de movilización
- Nuevo valor de movilización
- Aumento en movilización

**Formato de Salida:**

- Ordenado en forma descendente por el porcentaje de movilización

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 2

---

### CASO 3: Generación de Usuarios y Claves

**Contexto del Problema:**

En la actualidad, para conectarse a cualquier aplicación informática desarrollada para TRUCK RENTAL, los empleados utilizan un usuario genérico definido según el área en la que se desempeñen dentro de la empresa. Esta forma de trabajar debe ser modificada para garantizar:

- Tener un control de las acciones que cada usuario efectúa en las tablas de la Base de Datos
- Poder efectuar auditorías cuando los datos son manipulados intencionalmente
- Que cada empleado se pueda conectar a las aplicaciones sólo con el usuario que se le asigne y así evitar suplantación de identidad

**Requerimiento:**

Construcción de un módulo de seguridad que permita poder generar y controlar los usuarios y claves considerando las siguientes normas:

- **Nombre de Usuario**: Las tres primeras letras del primer nombre del empleado + el largo de su primer nombre + ASTERÍSTICO + el último dígito de su sueldo base + el dígito verificador del run del empleado + los años que lleva trabajando en la empresa
- **Clave del Usuario**: El tercer dígito del run del empleado + el año de contrato del empleado aumentado en dos + los tres últimos dígitos del sueldo base disminuido en uno + las dos últimas letras de su apellido paterno + el mes de la base de datos (en formato numérico)

**Información Requerida:**

- RUN del empleado
- Nombre completo del empleado
- Nombre de usuario (generado según regla)
- Clave del usuario (generada según regla)

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno del empleado

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 3

---

### CASO 4: Rebaja de Tarifas por Antigüedad

**Contexto del Problema:**

En el mes de enero de cada año, la Gerencia de TRUCK RENTAL define los precios de lista del arriendo y garantía por día que se cobrarán por cada camión. La decisión de rebajar los valores por cobro de arriendo y garantía está basada en la antigüedad del camión.

**Requerimiento:**

Proceso automático que rebaje los valores de arriendo y garantía según la antigüedad del camión:

- Si el camión tiene 10 años de antigüedad entonces el valor del arriendo por día y el valor de la garantía de ese camión se rebaja en un 10%
- Si la antigüedad del camión es de 8 años entonces el valor del arriendo por día y el valor de la garantía de ese camión se rebaja en un 8%
- Para rebajar estos valores el camión debe tener más de 5 años de antigüedad

**Información Requerida:**

- Número de patente
- Año de antigüedad del camión
- Valor arriendo sin rebajar
- Valor garantía sin rebajar
- Valor arriendo con rebaja
- Valor garantía con rebaja
- Año del proceso

**Formato de Salida:**

- Almacenar en tabla HIST_REBAJA_ARRIENDO
- Ordenado en forma descendente por año de antigüedad del camión
- Ordenado en forma ascendente por número de patente

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 4

---

### CASO 5: Multas por Retraso en Devolución

**Contexto del Problema:**

Uno de los compromisos que el cliente (arrendador) asume al firmar el contrato de arriendo es que el camión será devuelto al día siguiente del término del período por el cual fue arrendado y, por defecto, establece el derecho a que TRUCK RENTAL efectúe el cobro de una multa si esa devolución se efectúa fuera del plazo.

**Requerimiento:**

Proceso automático que mensualmente genere la información de las multas de arriendos del mes anterior al mes en que se ejecute.

**Información Requerida:**

- Número de patente del camión arrendado
- Fecha de inicio del arriendo del camión
- Total de días por el que se arrendó
- Fecha en que fue devuelto
- Días de atraso de la devolución
- Monto de la multa que se cobró

**Formato de Salida:**

- Ordenado en forma ascendente por fecha de inicio de arriendo del camión
- Ordenado en forma ascendente por número de patente del camión
- El valor diario de la multa debe ser ingresado en forma paramétrica

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 5

---

### CASO 6: Bonificación por Utilidades

**Contexto del Problema:**

Por contrato, a los encargados de arriendo de camiones se les paga una comisión mensual por cada vehículo que arrienden. Adicionalmente, en el mes de diciembre, a todos los empleados se les paga una bonificación especial que debido a que sólo se paga una vez al año no es imponible.

Sin embargo, para beneficiar a los empleados, la Gerencia ha decido que a contar del próximo año esta bonificación especial será un haber más en la remuneración mensual de los empleados y será solventada con las ganancias mensuales que obtenga la empresa.

**Requerimiento:**

Informe online que considere los datos del empleado, el valor de su sueldo base y el valor de la bonificación por utilidades. Los beneficiados serán los empleados que en el mes de proceso hayan arrendado un total de camiones mayor al promedio de camiones arrendados por empleado en ese mismo mes.

**Tramos de Bonificación:**

| Tramos Sueldo Base | Porcentaje Bonificación |
|-------------------|------------------------|
| $320.000 - $450.000 | 0,5% de las utilidades |
| $450.001 - $600.000 | 0,35% de las utilidades |
| $600.001 - $900.000 | 0,25% de las utilidades |
| $900.001 - $1.800.000 | 0,15% de las utilidades |
| $1.800.000 Y MAS | 0,1% de las utilidades |

**Información Requerida:**

- RUN del empleado
- Nombre completo del empleado
- Sueldo base
- Fecha proceso
- Bonificación por utilidades

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno del empleado
- El monto mensual de las utilidades debe ser ingresado en forma paramétrica

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 6

---

### CASO 7: Bonificación Extra de Movilización

**Contexto del Problema:**

Por ley, a cualquier persona que esté contratado en una empresa se le debe pagar movilización. En el caso de TRUCK RENTAL, el valor que se paga por este concepto corresponde a un porcentaje del sueldo base del empleado según los años que lleva trabajando en la empresa.

Como una forma de apoyar a sus empleados, la empresa ha definido pagar una bonificación mensual extra de movilización a los empleados que viven en las comunas más lejanas de la región metropolitana: María Pinto, Curacaví, El Monte, Paine y Pirque.

**Requerimiento:**

Informe para el SII con la información de los empleados a los cuales se les paga esta bonificación de movilización extra.

**Cálculo de Bonificación:**

- Si el sueldo base del empleado es igual o mayor a $450.000: el porcentaje de la bonificación será el primer dígito del sueldo base
- Si el sueldo base del empleado es menor a $450.000: el porcentaje de la bonificación serán los dos primeros dígitos del sueldo base

**Información Requerida:**

- RUN del empleado
- Nombre completo del empleado
- Comuna de residencia
- Sueldo base
- Movilización por ley
- Bonificación extra de movilización
- Total movilización

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno del empleado

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 7

---

## NOTAS IMPORTANTES

1. Todas las consultas deben usar funciones de fecha dinámicas (SYSDATE, ADD_MONTHS, etc.) y NO fechas fijas
2. Los valores paramétricos deben usar variables de sustitución (`&variable`)
3. El formato de salida debe coincidir exactamente con los ejemplos proporcionados
4. Las consultas deben estar optimizadas y usar los índices apropiados cuando sea necesario
5. Para el CASO 3, las funciones de cadena deben manejar correctamente los casos especiales (nombres cortos, etc.)
