# BANK SOLUTIONS - Casos de Recuperación de Datos

## Base de Datos

**Script de creación y poblado**: `DB/pobla_tablas_bank_solutions.sql`

---

## CONTEXTO DE NEGOCIO

**BANK SOLUTIONS** es una institución financiera que requiere gestión de información bancaria mediante bases de datos. La empresa gestiona información sobre clientes, productos de inversión, créditos, movimientos bancarios y sucursales.

### Estructura de Datos Principal

La base de datos incluye las siguientes entidades principales:

- **CLIENTE**: Información de clientes bancarios
- **PRODUCTO_INVERSION**: Productos de inversión ofrecidos
- **PRODUCTO_INVERSION_CLIENTE**: Relación cliente-producto de inversión
- **CREDITO**: Tipos de créditos disponibles
- **CREDITO_CLIENTE**: Créditos otorgados a clientes
- **CUOTA_CREDITO_CLIENTE**: Cuotas de los créditos
- **MOVIMIENTO**: Movimientos bancarios
- **SUCURSAL_BANCO**: Sucursales del banco
- **REGION, PROVINCIA, COMUNA**: Ubicaciones geográficas
- **PROFESION_OFICIO**: Profesiones y oficios
- **TIPO_CLIENTE**: Tipos de clientes
- **FORMA_PAGO**: Formas de pago

### Productos y Servicios

- **Productos de Inversión**: Cuentas de ahorro, depósitos a plazo, fondos mutuos
- **Créditos**: Hipotecarios, de consumo, automotriz, de emergencia, por pago de arancel
- **Gestión de Sucursales**: Múltiples sucursales distribuidas en diferentes regiones

---

## REQUERIMIENTOS A RESOLVER

### CASO 1: Vista - Clientes con Créditos de Monto Mayor al Promedio

**Contexto del Problema:**

La SBIF requiere información sobre créditos otorgados con montos mayores al promedio, incluyendo el aporte a la SBIF según rangos de monto definidos.

**Requerimiento:**

Crear una vista que muestre información de clientes que tienen créditos con monto mayor al promedio, incluyendo el aporte a la SBIF según rangos de monto.

**Información Requerida:**

- Mes de transacción
- Tipo de crédito
- Monto solicitado del crédito
- Aporte a la SBIF (según rangos)

**Rangos de Aporte a SBIF:**

| MONTO DEL CRÉDITO | APORTE PARA ENTREGAR A LA SBIF |
|------------------|-------------------------------|
| Entre $100.000 y $1.000.000 | 1% del monto del crédito |
| Entre $1.000.001 y $2.000.000 | 2% del monto del crédito |
| Entre $2.000.001 y $4.000.000 | 3% del monto del crédito |
| Entre $4.000.001 y $6.000.000 | 4% del monto del crédito |
| Mayor a $6.000.000 | 7% del monto del crédito |

**Formato de Salida:**

- Ordenado en forma ascendente por mes y nombre del crédito

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 1

**Archivo solución individual**: `SQL/Vista_Clientes_Cred_Monto_Mayor_Prom.SQL`

---

### CASO 2: Vista - Total de Créditos de Clientes por Año

**Contexto del Problema:**

La gerencia requiere información sobre el total de créditos que los clientes han solicitado durante el año para análisis de cartera crediticia.

**Requerimiento:**

Crear una vista que muestre el total de créditos que los clientes han solicitado durante el año anterior.

**Información Requerida:**

- RUN del cliente
- Nombre del cliente
- Total de créditos solicitados durante el año
- Monto total de los créditos (con la tasa de interés aplicada)

**Formato de Salida:**

- Ordenado alfabéticamente por apellido del cliente

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 2

**Archivo solución individual**: `SQL/Vista_Total_Creditos_Clientes_por_Ano.SQL`

---

### CASO 3: Vista - Clientes con Más Productos de Inversión

**Contexto del Problema:**

Para análisis de cartera de inversiones, se requiere identificar a los clientes que poseen mayor cantidad de productos de inversión contratados.

**Requerimiento:**

Crear una vista que muestre información de los clientes que poseen mayor cantidad de productos de inversión contratados en la institución.

**Información Requerida:**

- Año tributario
- RUN del cliente
- Nombre completo del cliente
- Total de productos de inversión afectos a impuesto
- Monto total ahorrado

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 3

**Archivo solución individual**: `SQL/Vista_Clientes_Con_Mas_Prod_Inv.SQL`

---

### CASO 4: Consulta - Clientes con Productos de Inversión para SII

**Contexto del Problema:**

Las entidades bancarias y financieras deben proporcionar al SII la información de los clientes que poseen depósitos a plazo y/o fondos mutuos.

**Requerimiento:**

Generar información de clientes dependientes que contrataron algún producto de inversión durante el año para el SII.

**Información Requerida:**

- RUN del cliente
- Nombre completo del cliente
- Producto de inversión
- Monto total ahorrado

**Formato de Salida:**

- Ordenado alfabéticamente por apellido paterno

**Solución SQL:** Ver `SQL/solucion.sql` - CASO 4

---

## ARCHIVOS RELACIONADOS

- **Base de Datos**: `DB/pobla_tablas_bank_solutions.sql`
- **Soluciones SQL**: `SQL/solucion.sql` - Contiene las 4 soluciones SQL completas

---

## NOTAS IMPORTANTES

1. Todas las consultas deben usar funciones de fecha dinámicas (SYSDATE, EXTRACT, etc.) y NO fechas fijas
2. Los valores paramétricos deben usar variables de sustitución (`&variable`)
3. El formato de salida debe coincidir exactamente con los ejemplos proporcionados
4. Las vistas deben ser creadas con `CREATE OR REPLACE VIEW` y pueden incluir `WITH READ ONLY` cuando sea necesario
5. Las consultas deben estar optimizadas y usar los índices apropiados cuando sea necesario

