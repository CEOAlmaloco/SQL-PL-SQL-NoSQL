# KOPERA - Casos de Recuperación de Datos

## Base de Datos

**Script de creación y poblado**: `DB/indices_crea_pobla_tablas_bd_KOPERA.SQL`

---

## CONTEXTO DE NEGOCIO

La Cooperativa de ahorro y crédito **KOPERA**, es una empresa establecida en gran parte del país. Su éxito se debe a las estrategias innovadoras que se han implementado en todos estos años para apoyar a sus socios y familiares, brindándoles la posibilidad de optar a créditos y ahorros a tasas de interés más atractivas que las ofrecidas por las entidades bancarias tradicionales.

### Tipos de Socios

La Cooperativa trabaja con tres tipos de socios:

- **Trabajadores dependientes**
- **Trabajadores independientes**
- **Pensionados y Tercera Edad**

### Productos de Inversión

Para que la inscripción sea válida, el socio debe optar por cualquiera de los productos de inversión que KOPERA dispone:

| Código | Nombre del Producto | Meses Mínimo Ahorro | Porcentaje Máximo Rescate |
|--------|---------------------|---------------------|---------------------------|
| 10 | Cuenta de Ahorro Dorada | 6 | 80% |
| 15 | Cuenta de Ahorro Tradicional | 12 | 60% |
| 20 | Cuenta de Ahorro Escolar | 48 | 100% |
| 25 | Cuenta de Ahorro para la Vivienda | 18 | 100% |
| 30 | Depósito a Plazo | 2 | 100% |
| 35 | Fondos Mutuos de Corto Plazo moneda Nacional | 2 | 100% |
| 40 | Fondos Mutuos de Corto Plazo moneda Extranjera | 2 | 100% |
| 45 | Fondos Mutuos Accionarios | 8 | 100% |
| 50 | Fondos Mutuos Diversificados | 4 | 100% |
| 55 | Fondos Mutuos de Libre Inversión en Renta Fija | 5 | 100% |

### Tipos de Créditos

La cooperativa cuenta con varios tipos de créditos:

| Código | Nombre del Crédito | Tasa de Interés Mensual | Nro. Máximo Cuotas |
|--------|-------------------|------------------------|-------------------|
| 1 | Crédito Hipotecario | 0.5% | 72 |
| 2 | Crédito de Consumo | 0.25% | 48 |
| 3 | Crédito Automotriz | 0.4% | 60 |
| 4 | Crédito de Emergencia | 0.35% | 48 |
| 5 | Crédito por pago de arancel | 0.80% | 48 |

### Reglas de Negocio

- Un socio puede solicitar todos los créditos que desee, siempre que cumpla con los requisitos
- Un socio sólo puede solicitar un máximo de 2 créditos diferentes en forma simultánea
- El banco tiene un plazo máximo de 5 días para aprobar o no el crédito
- El crédito rige a contar de su fecha de otorgación

### Desafíos y Objetivos

KOPERA debe efectuar cambios en su plataforma para cumplir con:

- Las exigencias de transparencia que la SBIF va a requerir
- La entrada en vigencia de la Ley de Créditos
- Obtener la certificación ISO 9001

El proyecto se llevará a cabo en **CUATRO ETAPAS**:

**ETAPA N°1**: Diseñar e implementar soluciones usando objetos para controlar el acceso y manipulación de la información.

**ETAPA N°2**: Diseñar e implementar una estrategia que permita restringir las acciones de los usuarios en la base de datos.

**ETAPA N°3**: Diseñar e implementar una política de creación y gestión de cuentas de usuarios de base de datos.

**ETAPA N°4**: Implementar la optimización de procesos desde la perspectiva del acceso a los datos.

---

## REQUERIMIENTOS A RESOLVER

### REQUERIMIENTO 1: Categorización de Clientes por Monto Ahorrado

**Contexto del Problema:**

Para obtener la certificación ISO 9001 es obligatorio que todos los procesos de gestión del negocio estén automatizados. Actualmente, la información de clientes categorizados se maneja a través de planillas Excel.

**Requerimiento:**

Diseñar y automatizar el proceso que genere anualmente la información de los clientes que poseen productos de inversión y/o de ahorro categorizados de acuerdo con el monto total ahorrado.

**Reglas de Negocio:**

- Por cada producto de inversión y/o de ahorro contratado por el cliente se completa una solicitud
- Cada producto posee un formulario de solicitud diferente con una numeración diferente
- El cliente al contratar un producto debe indicar el monto mínimo de ahorro mensual y el día del mes

**Categorización:**

| MONTO TOTAL AHORRADO | CATEGORIZACIÓN DEL CLIENTE |
|---------------------|---------------------------|
| Entre $100.000 y $1.000.000 | BRONCE |
| Entre $1.000.001 y $4.000.000 | PLATA |
| Entre $4.000.001 y $8.000.000 | SILVER |
| Entre $8.000.001 y $15.000.000 | GOLD |
| Mayor a $15.000.000 | PLATINUM |

**Requerimientos de Seguridad:**

- La consulta del informe debe quedar almacenada en el esquema correspondiente
- Solo el usuario autorizado puede consultar y modificar este informe

**Formato de Salida:**

- Ordenado alfabéticamente por el apellido paterno del cliente
- En forma descendente por monto total ahorrado
- El proceso se ejecuta el primer día hábil de cada año mostrando información del año anterior

**Solución SQL:** Ver `SQL/solucion.sql` - REQUERIMIENTO 1


---

### REQUERIMIENTO 2: Informe de Créditos para SBIF (Ley de Créditos)

**Contexto del Problema:**

A contar de enero del próximo año entrará en vigencia la Ley de Créditos que obliga a todos los Bancos e Instituciones Financieras a aportar un porcentaje de las ganancias de los créditos otorgados para la implementación de proyectos de formación de capital humano.

**Requerimiento:**

Diseñar y construir un informe que sea capaz de generar automáticamente toda la información requerida por la SBIF.

**Reglas de Negocio:**

- El banco tiene un plazo máximo de 5 días para aprobar o no el crédito
- El aporte a la SBIF está basado en el monto total del crédito (con la tasa de interés aplicada)
- El valor del aporte se define según la tabla APORTE_A_SBIF

**Rangos de Aporte a SBIF:**

| MONTO DEL CRÉDITO | APORTE PARA ENTREGAR A LA SBIF |
|------------------|-------------------------------|
| Entre $100.000 y $1.000.000 | 1% del monto del crédito |
| Entre $1.000.001 y $2.000.000 | 2% del monto del crédito |
| Entre $2.000.001 y $4.000.000 | 3% del monto del crédito |
| Entre $4.000.001 y $6.000.000 | 4% del monto del crédito |
| Mayor a $6.000.000 | 7% del monto del crédito |

**Requerimientos de Seguridad:**

- La consulta del informe DEBE quedar almacenada en el esquema correspondiente
- La consulta del informe NO puede usar los nombres reales de las tablas (debe usar sinónimos o vistas)

**Información Requerida:**

- Mes de transacción
- Tipo de crédito otorgado
- Monto total del crédito
- Monto total del aporte a la SBIF

**Formato de Salida:**

- Ordenado en forma ascendente por mes y nombre del crédito
- El proceso se ejecuta durante el mes de enero mostrando información del año anterior

**Solución SQL:** Ver `SQL/solucion.sql` - REQUERIMIENTO 2


---

### REQUERIMIENTO 3: Informe de Productos de Inversión para SII

**Contexto del Problema:**

Las entidades bancarias y financieras deben proporcionar al SII la información de los clientes que poseen depósitos a plazo y/o fondos mutuos. Esta información se debe enviar a través de un archivo que se debe ajustar al formato definido por el SII.

**Requerimiento:**

Modificar el proceso que genera el archivo para que esta información también quede almacenada en la base de datos. La información debe incluir encriptación según definición del SII.

**Información Requerida:**

- Año tributario (corresponde al año calendario en que se ejecutó el informe)
- RUN del cliente (encriptado)
- Nombre completo del cliente
- Cantidad total de productos de inversión tributables (encriptado)
- Monto total ahorrado por todos sus productos de inversión tributables (encriptado)

**Método de Encriptación SII:**

- RUN: Se debe aplicar método de encriptación según definición del SII
- Cantidad y Monto: Se debe aplicar método de encriptación según definición del SII

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno del cliente
- El archivo se envía al SII la primera semana de marzo

**Solución SQL:** Ver `SQL/solucion.sql` - REQUERIMIENTO 3


---

### REQUERIMIENTO 4: Informes de Balance para SBIF

**Contexto del Problema:**

Las nuevas exigencias de Transparencia definidas por la SBIF obligan que todas los bancos y entidades financieras informen sus activos y pasivos del balance anual.

**Requerimiento:**

Desarrollar dos informes obligatorios (prioridad 1):

**INFORME 1**: Detalle de todos los créditos otorgados durante el año considerando:
- RUN del cliente
- Nombre del cliente
- Total de créditos solicitados por el cliente durante el año
- Monto total de los créditos (con la tasa de interés aplicada) solicitados por el cliente durante el año

**INFORME 2**: Detalle de los abonos y rescates de los productos de inversión que los clientes han efectuado durante el año considerando:
- RUN del cliente
- Nombre del cliente
- Monto total de los abonos efectuados por el cliente durante el año
- Monto total de los rescates efectuados por el cliente durante el año

**Requerimientos de Seguridad:**

- Informe 1: Debe quedar almacenado en el esquema correspondiente
- Informe 2: Debe quedar almacenado en el esquema correspondiente

**Formato de Salida:**

- Ambos informes ordenados alfabéticamente por el apellido del cliente
- Los informes se ejecutan el primer día hábil de cada año mostrando información del año anterior

**Solución SQL:** Ver `SQL/solucion.sql` - REQUERIMIENTO 4

---

## NOTAS IMPORTANTES

1. Todas las consultas deben usar funciones de fecha dinámicas (SYSDATE, EXTRACT, etc.) y NO fechas fijas
2. Los valores paramétricos deben usar variables de sustitución (`&variable`)
3. El formato de salida debe coincidir exactamente con los ejemplos proporcionados
4. Las vistas deben ser creadas con `CREATE OR REPLACE VIEW` y pueden incluir `WITH READ ONLY`
5. Para REQUERIMIENTO 2, NO se pueden usar los nombres reales de las tablas (usar sinónimos o vistas)
6. Para REQUERIMIENTO 3, se debe aplicar método de encriptación según definición del SII
7. Los informes se ejecutan el primer día hábil de cada año mostrando información del año anterior
