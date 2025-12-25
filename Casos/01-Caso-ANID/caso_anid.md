## INSTRUCCIONES

## CONTEXTO DE NEGOCIO

La Agencia Nacional de Investigación y Desarrollo de Chile (ANID) es una corporación autónoma y funcionalmente descentralizada, con patrimonio propio y personalidad jurídica de Derecho Público, destinada a asesorar al Presidente de la República en el planeamiento del desarrollo científico y tecnológico, que promueve y fomenta la ciencia y la tecnología en Chile, orientándolas preferentemente al desarrollo económico y social del país.

Para estos efectos, ANID financia becas de postgrado en el extranjero para licenciados/as o profesionales de excelencia académica, siendo una de ellas la Beca de Especialidad Médica en el Extranjero para los médicos que se desempeñan en establecimientos de la salud pública del país.

Con este objetivo, ANID llama a concurso para otorgar becas a estos profesionales, chilenos/as y extranjeros/as con permanencia definitiva en Chile, para iniciar o continuar estudios en programas de especialidad del área de la medicina humana, que se desarrollen de manera presencial, continua, total y exclusivamente en el extranjero, sin perjuicio del nivel de idioma correspondiente que posean al momento de la postulación.

El concurso está destinado a otorgar becas de estudio en las áreas del conocimiento definidas para cada año y en las instituciones académicas que se encuentran clasificadas dentro de los primeros 200 lugares del Ranking de Instituciones Académicas por especialidad médica, según la información que publica ANID.

La Beca de Especialidad Médica en el Extranjero sólo financia estudios en programas que se desarrollen de manera presencial, continua, diurna, a tiempo completo y exclusivamente en el extranjero. Las Especialidades Médicas de Postulación pueden variar de un año a otro, así como las instituciones académicas en las que se imparten. Para poder optar a alguno de los programas de especialización, el postulante debe ingresar todos los antecedentes por vía electrónica mediante el Sistema de Postulación en Línea. Cada postulante sólo puede realizar una postulación al presente concurso.

En el apartado de Antecedentes Laborales, el postulante debe ingresar todos los establecimientos de salud pública en los cuales se desempeña y al Servicio de Salud al cual pertenece.

La publicación de los resultados se realiza en la página web la segunda semana de julio y en él se detallan los puntajes que cada postulante obtuvo en los cuatro criterios definidos para esta beca: por años de experiencia laboral, por la cantidad de horas que trabaja en establecimientos de salud pública, por trabajar en zona extrema, por ranking de la institución a la que postula. Existen también dos criterios extras por los cuales también se asignan puntajes. Estos criterios extras pueden variar cada año.

Además, esta información se envía esta información a los correos personales de cada postulante y en él también se les comunica el puntaje final que obtuvo y si fue seleccionado o no para realizar el programa de especialización médica al que postuló.

## REQUERIMIENTOS A RESOLVER

La gran necesidad del gobierno por agilizar, optimizar, flexibilizar y transparentar procesos del sistema público, ha motivado a utilizar en forma acelerada y sustancial las tecnologías de información para el desarrollo de aplicaciones cada vez más complejas, necesariamente apoyadas por arquitecturas dedicadas, especialmente diseñadas para trabajar de la manera más óptima, integrando sistemas, utilizando las mejores herramientas de gestión y desarrollando modelos adecuados a las necesidades de Gobierno.

Por esta razón, ha definido que todos los sistemas críticos sean rediseñados con el objetivo de cumplir las necesidades que requiere el sector público y que permitan contar con procesos confiables, eficientes y eficaces. En este contexto, el gobierno ha decido realizar diferentes licitaciones públicas para exteriorizar el rediseño y construcción de todos los sistemas de informáticos que tengan relación con becas de especialización disponibles para las diferentes áreas que aporten al desarrollo del país.

Uno de los sistemas que se deben rediseñar es el que gestiona la información de las postulaciones a la beca de especialización médicas en el extranjero para los médicos que trabajan en la salud pública y que, según los resultados de la licitación pública, la consultora responsable de realizar este trabajo será INFOR SOFTWARE en la cual Ud. trabaja.

De acuerdo a la prioridad definida por el usuario, el primer proceso a rediseñar es el que genera la información de los puntajes y resultados de los postulantes a esta beca del cual Ud. será responsable de construir de acuerdo con las reglas de negocio y especificaciones técnicas que se detallan.

## 1. REGLAS DE NEGOCIO

### 1.1. Puntaje por años de experiencia

El puntaje que se asigna por años de experiencia está relacionado directamente con los años que el postulante lleva trabajando en la salud pública. Como es factible que el postulante trabaje en más de una establecimiento de salud del sector público, se considera siempre la fecha de contrato más antigua.  
Los años de experiencia se calculan a la fecha de ejecución del proceso.  
El puntaje se debe obtener desde la tabla PTJE_ANNOS_EXPERIENCIA:

| RANGO_ANNOS_INI | RANGO_ANNOS_TER | PTJE_EXPERIENCIA |
|:----|:----|:----|
| 13 | 15 | 1000 |
| 16 | 20 | 1200 |
| 21 | 23 | 1300 |
| 24 | 26 | 1400 |
| 27 | 30 | 1600 |

### 1.2. Puntaje por horas trabajadas

El puntaje que se asigna por horas trabajadas está relacionado con el total de horas que el postulante trabaja en la salud pública. Como es factible que el postulante trabaje en más de un establecimiento de salud del sector público, se consideran las horas de trabajo de todos los establecimientos en los que trabaje. El puntaje se debe obtener desde la tabla PTJE_HORAS_TRABAJO.

| RANGO_HORAS_INI | RANGO_HORAS_TER | PTJE_HORAS_TRAB |
|:----|:----|:----|
| 10 | 15 | 1000 |
| 16 | 20 | 1200 |
| 21 | 25 | 1300 |
| 26 | 30 | 1400 |
| 31 | 35 | 1600 |
| 36 | 40 | 1800 |

### 1.3. Puntaje por zona extrema

El puntaje que se asigna por trabajar en zona extrema está relacionado a si el Servicio de Salud del que depende el establecimiento de salud en el que trabaja el postulante se encuentra ubicado en una zona extrema. Si el postulante trabaja en más de un establecimiento de salud, el Servicio de Salud es el mismo. El puntaje se debe obtener desde la tabla PTJE_ZONA_EXTREMA.

| ZONA_EXTREMA | PTJE_ZONA |
|:----|:----|
| 1 | 1000 |
| 2 | 1100 |
| 3 | 1200 |
| 4 | 1300 |
| 5 | 1400 |

### 1.4. Puntaje por ranking de institución

El puntaje que se asigna por ranking de la institución está relacionado con la institución que imparte el programa de especialización elegido por el postulante. Todas las instituciones que imparten algún programa de especialización están clasificadas por un ranking mundial. El puntaje se debe obtener desde la tabla PTJE_RANKING_INST.

| RANGO_RANKING_INI | RANGO_RANKING_TER | PTJE_RANKING |
|-----|-----|-----|
| 1 | 10 | 1600 |
| 11 | 20 | 1500 |
| 21 | 30 | 1400 |
| 31 | 40 | 1300 |
| 41 | 100 | 1200 |
| 101 | 150 | 1100 |
| 151 | 200 | 1000 |

### 1.5. Puntaje extra 1

A los postulantes que tienen menos de 45 años y además trabajan más de 30 horas se les asigna un puntaje adicional que corresponde al 30% de la sumatoria de los puntajes especificados en las reglas de negocio 1.1 a la 1.4. La edad del postulante se calcula a la fecha de ejecución del proceso.

### 1.6. Puntaje extra 2

A los postulantes que tienen más de 25 años de experiencia se les asigna un puntaje adicional que corresponde al 15% de la sumatoria de los puntajes especificados en las reglas de negocio 1.1 a la 1.4.

## 2. REQUERIMIENTOS MÍNIMOS OBLIGATORIOS, EN TÉRMINOS DE DISEÑO, PARA CONSTRUIR EL PROCESO

### 2.1. Package

Construir un PACKAGE que contenga los siguientes constructores públicos:

- Una Función para obtener el puntaje de la zona extrema en la que trabaja el postulante.

- Una Función para obtener el puntaje del ranking de la institución que dicta el programa de especialización elegido por el postulante.

- Dos Variables que se usen en el procedimiento almacenado principal para almacenar la información que Ud. defina.

### 2.2. Funciones Almacenadas

Construir dos FUNCIONES ALMACENADAS:

- Una Función Almacenada para obtener el puntaje por la cantidad de horas que trabaja el postulante. Esta función deberá controlar cualquier error que produzca al obtener la información. El error se debe almacenar en la tabla ERROR_PROCESO con el formato que se muestra en el ejemplo y el puntaje debe ser cero.

| NUMRUN | RUTINA_ERROR | MENSAJE_ERROR |
|:----|:----|:----|
| 11959215 | Error en FN_OBT_PTJE_HORAS_TRAB al obtener puntaje con horas de trabajo semanal: 8 | ORA-01403: No se ha encontrado ningun dato |

- Una Función Almacenada para obtener el puntaje por los años de experiencia del postulante. Como el postulante puede trabajar en más de un establecimiento de salud pública, se debe considerar la fecha de contrato más antigua. Esta función deberá controlar cualquier error que produzca al obtener la información. El error se debe almacenar en la tabla ERROR_PROCESO con el formato que se muestra en el ejemplo y el puntaje debe ser cero.

| NUMRUN | RUTINA_ERROR | MENSAJE_ERROR |
|:----|:----|:----|
| 10573148 | Error en FN_OBT_PTJE_ANNOS_EXPERIENCIA al obtener puntaje con anos de experiencia: 12 | ORA-01403: No se ha encontrado ningun dato |

### 2.3. Procedimiento Almacenado

Construir un PROCEDIMIENTO ALMACENADO:

- Este procedimiento Almacenado deberá generar la información de los postulantes a la beca, el puntaje que obtuvieron de acuerdo a las reglas de negocio especificadas y el resultado final. Para esto, deberá integrar el uso de los constructores del Package, las Funciones Almacenadas y el Trigger.

- Se deben considerar 3 parámetros de entrada al procedimiento para: la fecha de proceso, el 30% para el puntaje extra especificado en la regla de negocio 1.5 y el 15% para el puntaje extra especificado en la regla de negocio 1.6.

Debe procesar a todos los postulantes de la beca y generar la información requerida en la tabla DETALLE_PUNTAJE_POSTULACION. La información se debe almacenar ordenada por el run de los postulantes y en formato que se muestra en el ejemplo. La información requerida es: run del postulante, nombre del postulante, puntaje por años de experiencia, puntaje por horas de trabajo, puntaje por trabajar en zona extrema, puntaje por ranking de la institución, puntaje por tener menos de 45 años y además trabajar más de 30 horas (puntaje extra 1) y puntaje por tener más de 25 años de experiencia (puntaje extra 2).

- Se deben TRUNCAR, en tiempo de ejecución, las tablas de resultado del proceso: DETALLE_PUNTAJE_POSTULACION, ERROR_PROCESO y RESULTADO_POSTULACION.

### 2.4. Trigger

Construir un TRIGGER:

- Este trigger deberá generar la información de la tabla RESULTADO_POSTULACION. Esto significa que cuando el Procedimiento Almacenado genere la información de cada postulante en la tabla DETALLE_PUNTAJE_POSTULACION, en forma simultánea el trigger deberá almacenar en la tabla RESULTADO_POSTULACION: el run del postulante, el puntaje final y si quedó seleccionado para el programa de especialización.

- El puntaje final corresponde a la sumatoria de todos los puntajes especificados de las reglas de negocio 1.1. a la 1.6 (como se muestra en el ejemplo).

- Para que un postulante sea seleccionado al programa de especialización que postuló debe tener un puntaje total final o mayor a 4500.

- Si el puntaje final del postulante es igual o mayor a 4500 se debe almacenar el mensaje SELECCIONADO (como se muestra en el ejemplo).

- Si el puntaje final del postulante es menor a 4500 se debe almacenar el mensaje NO SELECCIONADO (como se muestra en el ejemplo).

### 2.5. Obtener puntajes

TODOS los puntajes se DEBEN obtener en Sentencias SELECT.

### 2.6. Redondeo de cálculos

TODOS los cálculos se DEBEN REDONDEAR.

## 3. DESARROLLO DE PROGRAMAS ADICIONALES

Además de los requerimientos mínimos establecidos en los puntos anteriores, Ud. posee la libertad de construir otros programas que considere mejorarán la eficiencia del proceso al obtener la información requerida.

## 4. PRUEBA Y RESULTADOS DEL PROCESO

### 4.1. Fecha de prueba

La prueba del proceso se debe realizar con fecha 30/06/2025.

### 4.2. Información de la tabla ERROR_PROCESO

| NUMRUN | RUTINA_ERROR | MENSAJE_ERROR |
|:----|:----|:----|
| 10573148 | Error en FN_OBT_PJTE_ANNOS_EXPERIENCIA al obtener puntaje con anos de experiencia: 12 | ORA-01403: No se ha encontrado ningun dato |
| 11959215 | Error en FN_OBT_PJTE_HORAS_TRAB al obtener puntaje con horas de trabajo semanal: 8 | ORA-01403: No se ha encontrado ningun dato |

### 4.3. Información de la tabla DETALLE_PUNTAJE_POSTULACION

| | NUM_POSTULANTE | NOMBRE_POSTULANTE | PTJE_ANNOS_DR | PTJE_HORAS_TRAB | PTJE_ZONA_EXTREMA | PTJE_RANKING_INST | PTJE_EXTRA_1 | PTJE_EXTRA_2 |
|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| 1 | 03.027.750-3 | PIDEL MBRI CHAVARRA PACHECO | 1300 | 1400 | 0 | 1200 | 0 | 0 |
| 2 | 03.126.425-1 | GREGORIA REGINA GONZALEZ CASTILLO | 1400 | 1800 | 1000 | 1500 | 0 | 855 |
| 3 | 03.490.261-5 | MARGARITA ANDERA CARES URBUTIA | 1600 | 1000 | 0 | 1500 | 0 | 615 |
| 4 | 03.758.049-K | HECTOR REHE ANDRADE PAUNDEZ | 1400 | 1400 | 1400 | 1200 | 0 | 0 |
| 5 | 03.943.337-D | ISIDORO EDUARDO ORDEHES HORMAZARAL | 1600 | 1200 | 0 | 1100 | 0 | 585 |
| 6 | 04.582.433-O | BARTOLONE IGNACIO PARRA PARRA | 1400 | 1800 | 0 | 1600 | 0 | 0 |
| 7 | 04.808.258-O | POLICARPO HIPOLITO URBUTIA MUÑOZ | 1600 | 1400 | 0 | 1400 | 0 | 660 |
| 8 | 05.412.514-3 | MARIA MAGDALENA BELTRAN JAÑA | 1600 | 1400 | 1400 | 1200 | 0 | 840 |
| 9 | 05.588.583-4 | MARIA MARGARITA FERNANDEZ FERNANDEZ | 1600 | 1400 | 1100 | 1600 | 0 | 855 |
| 10 | 05.644.453-K | MAHUEL CARLOS ARAVEHA PUBHTEALBA | 1200 | 1000 | 0 | 1100 | 0 | 0 |
| 26 | 09.827.836-2 | JOSE GASTON ROCHA LARA | 1400 | 1600 | 1300 | 1400 | 1710 | 0 |
| 27 | 10.006.101-5 | JOSE ROCHA LARA PEREZ | 1400 | 1200 | 0 | 1600 | 0 | 0 |
| 28 | 10.066.612-K | LUIS JAÑA URBINA PARRA | 1000 | 1800 | 1400 | 1600 | 1740 | 0 |
| 29 | 10.214.564-K | VIVIANA JACQUELINE ALARCON CACERES | 1200 | 1200 | 0 | 1100 | 0 | 0 |
| 30 | 10.282.370-K | TANIA ALEJANDRA RAHAMONDEE PEREZ | 1400 | 1800 | 0 | 1600 | 0 | 0 |
| 31 | 10.573.148-5 | FRANCISCO PUENTES GONZALEZ ZAPATA | 0 | 1600 | 1200 | 1600 | 0 | 0 |
| 32 | 10.726.792-1 | VIVIANA ALARCON CACERES CIFUENTES | 1200 | 1800 | 0 | 1600 | 1380 | 0 |
| 33 | 10.805.156-6 | MARIA BELTRAN GARCIA SILVA | 1400 | 1400 | 0 | 1200 | 0 | 0 |
| 34 | 10.834.039-8 | JOSE ALBERTO BADILLA LEAL | 1000 | 1800 | 0 | 1500 | 0 | 0 |
| 45 | 13.770.506-0 | EDUARDO CASTILLO CASTILLO JARA | 1200 | 1000 | 0 | 1200 | 0 | 0 |
| 46 | 13.877.357-4 | GREGORIA GONZALEZ CASTILLO CACERES | 1200 | 1300 | 1000 | 1500 | 0 | 0 |
| 47 | 13.996.528-0 | AIA ROSARIO BETANZO TURNER | 1200 | 1200 | 0 | 1200 | 0 | 0 |
| 48 | 14.030.150-7 | BLANCA MENDOZA ROJAS HORMAZARAL | 1200 | 1000 | 0 | 1500 | 0 | 0 |
| 49 | 14.284.031-6 | LUIS GUILLERMO JARA URBINA | 1000 | 1000 | 0 | 1600 | 0 | 0 |
| 50 | 14.353.190-2 | MARGARITA CARES URBUTIA PACHECO | 1000 | 1400 | 1300 | 1500 | 0 | 0 |
| 51 | 14.490.825-2 | GLORIA ISABEL HERMANDEZ ZAPATA | 1200 | 1600 | 0 | 1600 | 1320 | 0 |

### 4.4. Información de la tabla RESULTADO_PROCESO

| RUN_POSTULANTE | PTJE_FINAL_POST | RESULTADO_POST |
|-----|-----|-----|
| 03.027.750-3 | 3900 | NO SELECCIONADO |
| 03.126.425-1 | 6555 | SELECCIONADO |
| 03.490.261-5 | 4715 | SELECCIONADO |
| 03.758.049-K | 5400 | SELECCIONADO |
| 03.943.337-O | 4485 | NO SELECCIONADO |
| 04.582.433-O | 4800 | SELECCIONADO |
| 04.808.258-O | 5060 | SELECCIONADO |
| 05.412.514-3 | 6440 | SELECCIONADO |
| 05.588.583-4 | 6555 | SELECCIONADO |
| 05.644.453-K | 3300 | NO SELECCIONADO |
| 09.827.836-2 | 7410 | SELECCIONADO |
| 10.006.101-5 | 4200 | NO SELECCIONADO |
| 10.066.612-K | 7540 | SELECCIONADO |
| 10.214.564-K | 3500 | NO SELECCIONADO |
| 10.282.370-K | 4800 | SELECCIONADO |
| 10.573.148-5 | 4400 | NO SELECCIONADO |
| 10.726.792-1 | 5980 | SELECCIONADO |
| 10.805.156-6 | 4000 | NO SELECCIONADO |
| 10.834.039-8 | 4300 | NO SELECCIONADO |
| 13.770.506-O | 3400 | NO SELECCIONADO |
| 13.877.357-4 | 5000 | SELECCIONADO |
| 13.996.528-O | 3600 | NO SELECCIONADO |
| 14.030.150-7 | 3700 | NO SELECCIONADO |
| 14.284.031-6 | 3600 | NO SELECCIONADO |
| 14.353.190-2 | 5200 | SELECCIONADO |
| 14.490.825-2 | 5720 | SELECCIONADO |
