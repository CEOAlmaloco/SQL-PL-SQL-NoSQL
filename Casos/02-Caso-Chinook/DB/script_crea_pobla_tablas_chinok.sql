ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';
DROP TABLE banco CASCADE CONSTRAINTS;
DROP TABLE boleta CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE comuna CASCADE CONSTRAINTS;
DROP TABLE detalle_boleta CASCADE CONSTRAINTS;
DROP TABLE detalle_factura CASCADE CONSTRAINTS;
DROP TABLE error_procesos_mensuales CASCADE CONSTRAINTS;
DROP TABLE factura CASCADE CONSTRAINTS;
DROP TABLE forma_pago CASCADE CONSTRAINTS;
DROP TABLE pago_vendedor CASCADE CONSTRAINTS;
DROP TABLE pais CASCADE CONSTRAINTS;
DROP TABLE producto CASCADE CONSTRAINTS;
DROP TABLE promocion CASCADE CONSTRAINTS;
DROP TABLE rango_aumento_porc_col CASCADE CONSTRAINTS;
DROP TABLE rangos_sueldos CASCADE CONSTRAINTS;
DROP TABLE unidad_medida CASCADE CONSTRAINTS;
DROP TABLE vendedor CASCADE CONSTRAINTS;

DROP SEQUENCE seq_error;





CREATE TABLE banco (
    codbanco     NUMBER(2) NOT NULL,
    descripcion  VARCHAR2(30)
);

ALTER TABLE banco ADD CONSTRAINT codbanco_pk PRIMARY KEY ( codbanco );

CREATE TABLE boleta (
    numboleta       NUMBER(7) NOT NULL,
    rutcliente      VARCHAR2(10),
    rutvendedor     VARCHAR2(10),
    fecha           DATE,
    total           NUMBER(7),
    codpago         NUMBER(2),
    codbanco        NUMBER(2),
    num_docto_pago  VARCHAR2(30),
    estado          VARCHAR2(2)
);

ALTER TABLE boleta
    ADD CONSTRAINT bol_estado_boleta_ck CHECK ( estado IN ( 'EM', 'NC', 'PA' ) );

ALTER TABLE boleta ADD CONSTRAINT numboleta_pk PRIMARY KEY ( numboleta );

CREATE TABLE ciudad (
    codciudad    NUMBER(2) NOT NULL,
    descripcion  VARCHAR2(30)
);

ALTER TABLE ciudad ADD CONSTRAINT cod_ciudad_pk PRIMARY KEY ( codciudad );

CREATE TABLE cliente (
    id_cliente   NUMBER(2),
    rutcliente   VARCHAR2(10) NOT NULL,
    nombre       VARCHAR2(30),
    direccion    VARCHAR2(30),
    codcomuna    NUMBER(2),
    telefono     NUMBER(10),
    estado       VARCHAR2(1),
    mail         VARCHAR2(50),
    credito      NUMBER(7),
    saldo        NUMBER(7),
    fecha_carga  DATE
);

ALTER TABLE cliente
    ADD CONSTRAINT estado_cliente_ck CHECK ( estado IN ( 'A', 'B' ) );

ALTER TABLE cliente ADD CONSTRAINT rut_cliente_pk PRIMARY KEY ( rutcliente );

CREATE TABLE comuna (
    codcomuna    NUMBER(2) NOT NULL,
    descripcion  VARCHAR2(30),
    codciudad    NUMBER(2)
);

ALTER TABLE comuna ADD CONSTRAINT cod_comuna_pk PRIMARY KEY ( codcomuna );

CREATE TABLE detalle_boleta (
    numboleta     NUMBER(7) NOT NULL,
    codproducto   NUMBER(3) NOT NULL,
    vunitario     NUMBER(8),
    codpromocion  NUMBER(4),
    descri_prom   VARCHAR2(60),
    descuento     NUMBER(8),
    cantidad      NUMBER(5),
    totallinea    NUMBER(8)
);

ALTER TABLE detalle_boleta ADD CONSTRAINT det_boleta_pk PRIMARY KEY ( numboleta,
                                                                      codproducto );

CREATE TABLE detalle_factura (
    numfactura    NUMBER(7) NOT NULL,
    codproducto   NUMBER(3) NOT NULL,
    vunitario     NUMBER(8),
    codpromocion  NUMBER(4),
    descri_prom   VARCHAR2(60),
    descuento     NUMBER(8),
    cantidad      NUMBER(5),
    totallinea    NUMBER(8)
);

ALTER TABLE detalle_factura ADD CONSTRAINT det_fact_pk PRIMARY KEY ( numfactura,
                                                                     codproducto );

CREATE TABLE error_procesos_mensuales (
    correl_error   NUMBER(5) NOT NULL,
    rutina_error   VARCHAR2(70) NOT NULL,
    descrip_error  VARCHAR2(255) NOT NULL
);

ALTER TABLE error_procesos_mensuales ADD CONSTRAINT pk_error_procs_mensuales PRIMARY KEY ( correl_error );

CREATE TABLE factura (
    numfactura      NUMBER(7) NOT NULL,
    rutcliente      VARCHAR2(10),
    rutvendedor     VARCHAR2(10),
    fecha           DATE,
    f_vencimiento   DATE,
    neto            NUMBER(7),
    iva             NUMBER(7),
    total           NUMBER(7),
    codbanco        NUMBER(2),
    codpago         NUMBER(2),
    num_docto_pago  VARCHAR2(30),
    estado          VARCHAR2(2)
);

ALTER TABLE factura
    ADD CONSTRAINT estado_factura_ck CHECK ( estado IN ( 'EM', 'NC', 'PA' ) );

ALTER TABLE factura ADD CONSTRAINT numfactura_pk PRIMARY KEY ( numfactura );

CREATE TABLE forma_pago (
    codpago      NUMBER(2) NOT NULL,
    descripcion  VARCHAR2(30)
);

ALTER TABLE forma_pago ADD CONSTRAINT codpago_pk PRIMARY KEY ( codpago );

CREATE TABLE pago_vendedor (
    mes_anno      VARCHAR2(10) NOT NULL,
    rutvendedor   VARCHAR2(10) NOT NULL,
    nomvendedor   VARCHAR2(30) NOT NULL,
    sueldo_base   NUMBER(8) NOT NULL,
    comision_mes  NUMBER(8) NOT NULL,
    colacion      NUMBER(8) NOT NULL,
    movilizacion  NUMBER(8) NOT NULL,
    prevision     NUMBER(8) NOT NULL,
    salud         NUMBER(8) NOT NULL,
    total_pagar   NUMBER(8) NOT NULL
);

ALTER TABLE pago_vendedor ADD CONSTRAINT pago_vendedor_pk PRIMARY KEY ( mes_anno,
                                                                        rutvendedor );

CREATE TABLE pais (
    codpais  NUMBER(2) NOT NULL,
    nompais  VARCHAR2(30)
);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( codpais );

CREATE TABLE producto (
    codproducto       NUMBER(3) NOT NULL,
    descripcion       VARCHAR2(40),
    codunidad         VARCHAR2(2),
    codcategoria      VARCHAR2(1),
    vunitario         NUMBER(8),
    valorcomprapeso   NUMBER(8),
    valorcompradolar  NUMBER(8, 2),
    totalstock        NUMBER(5),
    stkseguridad      NUMBER(5),
    procedencia       VARCHAR2(1),
    codpais           NUMBER(2),
    codproducto_rel   NUMBER(3)
);

ALTER TABLE producto ADD CONSTRAINT cod_prod_pk PRIMARY KEY ( codproducto );

CREATE TABLE promocion (
    codpromocion     NUMBER(4) NOT NULL,
    descri_prom      VARCHAR2(60),
    fecha_desde      DATE,
    fecha_hasta      DATE,
    codproducto      NUMBER(3),
    porc_dscto_prod  NUMBER(4, 2),
    codproducto_rel  NUMBER(3),
    imagen           BLOB DEFAULT empty_blob()
);

ALTER TABLE promocion ADD CONSTRAINT codpromocion_pk PRIMARY KEY ( codpromocion );

CREATE TABLE rango_aumento_porc_col (
    id_rango      NUMBER(3) NOT NULL,
    edad_min      NUMBER(2) NOT NULL,
    edad_max      NUMBER(2) NOT NULL,
    porc_aumento  NUMBER(3) NOT NULL
);

ALTER TABLE rango_aumento_porc_col ADD CONSTRAINT rango_aumento_porc_col_pk PRIMARY KEY ( id_rango );

CREATE TABLE rangos_sueldos (
    cod_rango       NUMBER(2) NOT NULL,
    sueldo_min      NUMBER(8) NOT NULL,
    sueldo_max      NUMBER(8) NOT NULL,
    porc_honorario  NUMBER(4, 2) NOT NULL
);

ALTER TABLE rangos_sueldos ADD CONSTRAINT pk_rangos PRIMARY KEY ( cod_rango );

CREATE TABLE unidad_medida (
    codunidad    VARCHAR2(2) NOT NULL,
    descripcion  VARCHAR2(30)
);

ALTER TABLE unidad_medida ADD CONSTRAINT cod_unidad_pk PRIMARY KEY ( codunidad );

CREATE TABLE vendedor (
    id_vendedor   NUMBER(2),
    rutvendedor   VARCHAR2(10) NOT NULL,
    nombre        VARCHAR2(30),
    direccion     VARCHAR2(30),
    codcomuna     NUMBER(2),
    telefono      NUMBER(10),
    mail          VARCHAR2(50),
    sueldo_base   NUMBER(8),
    comision      NUMBER(2, 2),
    hora_inicio   VARCHAR2(5) NOT NULL,
    hora_termino  VARCHAR2(5) NOT NULL,
    fecha_nac     DATE NOT NULL
);


Prompt ******  CREANDO SECUENCIA SEQ_ERROR ....

create sequence SEQ_ERROR
minvalue 1
maxvalue 9999999999
increment by 1;


ALTER TABLE vendedor ADD CONSTRAINT rut_vendedor_pk PRIMARY KEY ( rutvendedor );

ALTER TABLE boleta
    ADD CONSTRAINT bol_codbanco_fk FOREIGN KEY ( codbanco )
        REFERENCES banco ( codbanco );

ALTER TABLE boleta
    ADD CONSTRAINT bol_codpago_fk FOREIGN KEY ( codpago )
        REFERENCES forma_pago ( codpago );

ALTER TABLE boleta
    ADD CONSTRAINT bol_rutcliente_fk FOREIGN KEY ( rutcliente )
        REFERENCES cliente ( rutcliente );

ALTER TABLE boleta
    ADD CONSTRAINT bol_rutvendedor_fk FOREIGN KEY ( rutvendedor )
        REFERENCES vendedor ( rutvendedor );

ALTER TABLE comuna
    ADD CONSTRAINT cod_ciudad_fk FOREIGN KEY ( codciudad )
        REFERENCES ciudad ( codciudad );

ALTER TABLE cliente
    ADD CONSTRAINT cod_comuna_fk FOREIGN KEY ( codcomuna )
        REFERENCES comuna ( codcomuna );

ALTER TABLE producto
    ADD CONSTRAINT cod_pais_fk FOREIGN KEY ( codpais )
        REFERENCES pais ( codpais );

ALTER TABLE detalle_factura
    ADD CONSTRAINT cod_prod_fk FOREIGN KEY ( codproducto )
        REFERENCES producto ( codproducto );

ALTER TABLE producto
    ADD CONSTRAINT cod_unidad_fk FOREIGN KEY ( codunidad )
        REFERENCES unidad_medida ( codunidad );

ALTER TABLE factura
    ADD CONSTRAINT codbanco_fk FOREIGN KEY ( codbanco )
        REFERENCES banco ( codbanco );

ALTER TABLE factura
    ADD CONSTRAINT codpago_fk FOREIGN KEY ( codpago )
        REFERENCES forma_pago ( codpago );

ALTER TABLE promocion
    ADD CONSTRAINT codproducto_fk FOREIGN KEY ( codproducto )
        REFERENCES producto ( codproducto );

ALTER TABLE producto
    ADD CONSTRAINT codproducto_rel_fk FOREIGN KEY ( codproducto_rel )
        REFERENCES producto ( codproducto );

ALTER TABLE detalle_factura
    ADD CONSTRAINT codpromocion_fk FOREIGN KEY ( codpromocion )
        REFERENCES promocion ( codpromocion );

ALTER TABLE detalle_boleta
    ADD CONSTRAINT det_bol_codproducto_fk FOREIGN KEY ( codproducto )
        REFERENCES producto ( codproducto );

ALTER TABLE detalle_boleta
    ADD CONSTRAINT det_bol_codpromocion_fk FOREIGN KEY ( codpromocion )
        REFERENCES promocion ( codpromocion );

ALTER TABLE detalle_boleta
    ADD CONSTRAINT det_bol_num_boleta_fk FOREIGN KEY ( numboleta )
        REFERENCES boleta ( numboleta );

ALTER TABLE detalle_factura
    ADD CONSTRAINT num_fact_fk FOREIGN KEY ( numfactura )
        REFERENCES factura ( numfactura );

ALTER TABLE factura
    ADD CONSTRAINT rutcliente_fk FOREIGN KEY ( rutcliente )
        REFERENCES cliente ( rutcliente );

ALTER TABLE factura
    ADD CONSTRAINT rutvendedor_fk FOREIGN KEY ( rutvendedor )
        REFERENCES vendedor ( rutvendedor );

ALTER TABLE vendedor
    ADD CONSTRAINT vendedor_cod_comuna_fk FOREIGN KEY ( codcomuna )
        REFERENCES comuna ( codcomuna );


-- INSERTANDO DATOS ....

INSERT INTO CIUDAD VALUES (1,'ARICA');
INSERT INTO CIUDAD VALUES (2,'IQUIQUE');
INSERT INTO CIUDAD VALUES (3,'CALAMA');
INSERT INTO CIUDAD VALUES (4,'ANTOFAGASTA');
INSERT INTO CIUDAD VALUES (5,'COPIAPO');
INSERT INTO CIUDAD VALUES (6,'LA SERENA');
INSERT INTO CIUDAD VALUES (7,'VALPARAISO');
INSERT INTO CIUDAD VALUES (8,'SANTIAGO');
INSERT INTO CIUDAD VALUES (9,'RANCAGUA');
INSERT INTO CIUDAD VALUES (10,'TALCA');
INSERT INTO CIUDAD VALUES (11,'CONCEPCION');
INSERT INTO CIUDAD VALUES (12,'TEMUCO');
INSERT INTO CIUDAD VALUES (13,'VALDIVIA');
INSERT INTO CIUDAD VALUES (14,'OSORNO');
INSERT INTO CIUDAD VALUES (15,'PTO. MONTT');
INSERT INTO CIUDAD VALUES (16,'COYHAIQUE');
INSERT INTO CIUDAD VALUES (17,'PTA. ARENAS');

INSERT INTO COMUNA VALUES (1,'VITACURA',8);
INSERT INTO COMUNA VALUES (2,'NUNOA',8);
INSERT INTO COMUNA VALUES (3,'PENALOLEN',8);
INSERT INTO COMUNA VALUES (4,'SANTIAGO',8);
INSERT INTO COMUNA VALUES (5,'VALDIVIA',13);
INSERT INTO COMUNA VALUES (6,'EL LOA',3);
INSERT INTO COMUNA VALUES (7,'CHILLAN',11);
INSERT INTO COMUNA VALUES (8,'PROVIDENCIA',8);
INSERT INTO COMUNA VALUES (9,'PTO.SAAVEDRA',14);

INSERT INTO FORMA_PAGO VALUES (1,'EFECTIVO');
INSERT INTO FORMA_PAGO VALUES (2,'TARJETA DEBITO');
INSERT INTO FORMA_PAGO VALUES (3,'TARJETA CREDITO');
INSERT INTO FORMA_PAGO VALUES (4,'CHEQUE');

INSERT INTO BANCO VALUES (1,'CHILE');
INSERT INTO BANCO VALUES (2,'SANTANDER');
INSERT INTO BANCO VALUES (3,'BCI');
INSERT INTO BANCO VALUES (4,'CORP BANCA');
INSERT INTO BANCO VALUES (5,'BbVA');
INSERT INTO BANCO VALUES (6,'SCOTIABANK');
INSERT INTO BANCO VALUES (7,'SECURITY');

INSERT INTO UNIDAD_MEDIDA VALUES ('UN','UNITARIO');
INSERT INTO UNIDAD_MEDIDA VALUES ('LT','LITRO');
INSERT INTO UNIDAD_MEDIDA VALUES ('MT','METRO');

INSERT INTO PAIS VALUES (1,'CHILE');
INSERT INTO PAIS VALUES (2,'EEUU');
INSERT INTO PAIS VALUES (3,'INGLATERRA');
INSERT INTO PAIS VALUES (4,'ALEMANIA');
INSERT INTO PAIS VALUES (5,'FrancIA');
INSERT INTO PAIS VALUES (6,'CANADA');
INSERT INTO PAIS VALUES (7,'ARGENTINA');
INSERT INTO PAIS VALUES (8,'BRASIL');


INSERT INTO rangos_sueldos VALUES (2, 300001, 700000, .38);
INSERT INTO rangos_sueldos VALUES (3, 500001, 900000, .36);
INSERT INTO rangos_sueldos VALUES (4, 900001, 1300000, .34);
INSERT INTO rangos_sueldos VALUES (5, 1300001,1500000, .3);
INSERT INTO rangos_sueldos VALUES (6, 1500001,2000000, .28);
INSERT INTO rangos_sueldos VALUES (7, 2000001,3000000, .26);
INSERT INTO rangos_sueldos VALUES (8, 3000001,5000000, .24);


 
insert into rango_aumento_porc_col values (1,18,25,2);
insert into rango_aumento_porc_col values (2,15,50,5);
insert into rango_aumento_porc_col values (3,41,55,8);
insert into rango_aumento_porc_col values (4,55,80,10);


insert into cliente values (1,'6245678-1','JUAN ORMEÑO','ALAMEDA 6152',8,96644123,'A','JLOPEZ@GMAIL.COM',1000000,696550, '01/08/2020');
insert into cliente values (2,'7812354-2','MARIA SANTANDER','APOQUINDO 9093',8,961682456,'A','MSANTANDER@HOTMAIL.COM',1000000,819120,'11/09/2020');
insert into cliente values (3,'9912478-3','SIGIFRIDO GUASINI   ','BILBAO 6200',8,55877315,'B','SSILVA@GMAIL.COM',1500000,0,'12/08/2020');
insert into cliente values (4,'14456789-4','OSCAR LARA','ALAMEDA 960',NULL,79888222,'A','OLARA@GMAIL.COM',2500000,2000000,'13/08/2020');
insert into cliente values (5,'11245678-5','MARCO ITURRA','ALAMEDA 1056',8,94577804,'A','MITURRA@YAHOO.COM',3000000,2332410, '11/09/2020');
insert into cliente values (6,'6467708-6','MARIBEL CARRASCO','VICUñaA MACKENNA 4555',4,95514545,'A','MSOTO@GMAIL.COM',1800000,1200000, '11/08/2020');
insert into cliente values (7,'10125945-7','SABINA LOPEZ','AV. LA FLORIDA 15554 ',4,88656285,'A','SVERGARA@GMAIL.COM',500000,150000, '12/09/2020');
insert into cliente values (8,'8125781-8','PATRICIO FUENTES','IRARRAZABAL 5452',2,74545904,'A','PFUENTES@HOTMAIL.COM',450000,50000,'10/08/2020');
insert into cliente values (9,'13746912-9','ABRAHAM IGLESIAS','ALAMEDA 454',4,91452303,'A','AIGLESIAS@YAHOO.COM',100000,90000, '10/09/2020');
insert into cliente values (10,'5446780-0','LEANDRO MESSI ','PANAMERICANA 152',1,95754782,'A','LMESSI@GMAIL.COM',800000,550000, '10/08/2020');
insert into cliente values (11,'10812874-0','ELBA  FUENZALIDA','PROVIDENCIA 4587 ',NULL,78544452,'A','LFUENZALIDA@GMAIL.COM',1900000,790000, '11/08/2020');

insert into VENDEDOR values (1,'12456778-1','LEOPOLDO JOSÉ VALLEJOS','ALAMEDA 6152',1,44644123,'LvallejoS@GMAIL.COM',340000,0.1, '10:00', '18:00','19/08/2001' );
insert into VENDEDOR values (2,'10712354-2','MARIO ANDRÉS SOTO ','APOQUINDO 9093',2,651682456,'MSOTO@HOTMAIL.COM',665000,0.2 , '17:10', '21:15', '11/11/2003');
insert into VENDEDOR values (3,'11124678-3','SALVADOR ALVARADO','BILBAO 6200',3,65877315,'SALVARADiu@GMAIL.COM',350000,0.3 , '10:15', '16:00','11/10/1997');
insert into VENDEDOR values (4,'10656569-K','Luis  CarLOS MUñoOZ','ALAMEDA 960',4,96888222,'wenardo@GMAIL.COM',565000,0.4 , '11:00', '21:58','01/07/1994');
insert into VENDEDOR values (5,'1097470-K','Luis  Pedro Morales','Holanda  0029',1,96000255,'pdri@GMAIL.COM',565000,0.1 , '11:00', '21:00','06/02/1994');
insert into VENDEDOR values (6,'6182133-8','Carlos Joaquín  MUÑOZ','Pasaje 33 960',4,9555333,'joaco@GMAIL.COM',465000,0.1 , '11:00', '21:00','01/03/1994');
insert into VENDEDOR values (7,'13566589-K','Sabina Marta Morgado','Apoquindo  960',4,75666222,'morguita@GMAIL.COM',335000,0.2 , '11:00', '13:00','01/02/1994');
insert into VENDEDOR values (8,'17456000-1','Mario  José Pereira','Vitacura  60',4,932323882,'LmmmOZ@GMAIL.COM',1265000,0.1 , '10:00', '17:00','01/08/1995');
insert into VENDEDOR values (9,'17776789-4','Luis Felipe MUÑOZ','ALAMos 1960',9,44433222,'fMUNOZ@GMAIL.COM',625000,0.3 , '12:00', '21:00','01/08/1992');
insert into VENDEDOR values (11,'15489899-1','Laura Soledad Sotelo','R. Dario 110',9,99575722,'Lsotelo@GMAIL.COM',650090,0.2 , '16:00', '21:00','09/08/1993');
insert into VENDEDOR values (12,'10456789-4','Claudio Valdes  ','Vicuna M 0030',2,65168456,'ven@GMAIL.COM',654880,0.2 , '11:30', '14:09','11/09/1985');
insert into VENDEDOR values (13,'10125945-7','PEDRO Gonzalez','ALAMEDA 9699',2,9437474,'malardo@GMAIL.COM',126500,0.1 , '10:10', '15:00','12/08/1992');



INSERT INTO PRODUCTO VALUES (1, 'AMALIE ELIXIR FULL SYNTHETIC SAE 5W-30'                  ,'LT','P',25000,4000,7.42,100,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (2, 'CASTROL EDGE USA 5W-30 6 QUARTS'             ,'LT','P',12500,8890,8.87,90,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (3, 'CASTROL EDGE 0W-30 946'                      ,'LT','P',10000,7990,7.09,54,5,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (4, 'LIQUI MOLY TOURING HIGH TECH 15W-40'               ,'LT','P',8500,6770.5,07,40,4,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (5, 'HYUNDAI XTEER G7000 10W-40'                        ,'LT','P',4950,3950,4.03,40,4,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (6, 'MOBIL SUPER S 2000 10W-40 GASOLINA'                ,'LT','P',7850,5679,7.98,60,6,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (7, 'ROYAL PURPLE 5W-30 HIGH PERFORMANCE 946'           ,'LT','P',11990,9500,9.77,87,10,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (8, 'VALVOLINE SYNPOWER SAE 5W-40'                ,'LT','P',12500,10890,12.76,60,6,'I',8,NULL);
INSERT INTO PRODUCTO VALUES (9, 'YPF ELAION F10 SAE 15W-40'                   ,'LT','P',18990,15000,17.85,18,5,'I',8,NULL);
INSERT INTO PRODUCTO VALUES (10,'Filtro ACEITE  Navara New'                         ,'UN','P',2500,1500,2.01,100,10,'I',8,NULL);
INSERT INTO PRODUCTO VALUES (11,'Filtro ACEITE  Motorcraft 1990'                    ,'UN','P',1850,1200,1.6,150,15,'I',7,NULL);
INSERT INTO PRODUCTO VALUES (12,'Filtro De Aceite Np300 Diesel Original'                  ,'UN','P',15000,11000,15.64,70,7,'I',7,NULL);
INSERT INTO PRODUCTO VALUES (13,'Filtro ACEITE  Motorcraft Fl-910-s'                      ,'UN','P',9000,6400,8.15,69,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (14,'Filtro De ACEITE Bmw Hengst 61hd215'               ,'UN','P',17980,13980,15.85,35,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (15,'ADITIVO AUMENTADOR DE OCTANAJE 473'          ,'UN','P',12990,9000,8.77,20,2,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (16,'ADITIVO ROYAL PURPLE MAX-CLEAN 177'                ,'UN','P',6990,5000,5.50,54,10,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (17,'HIGH PERFORMANCE valvoline 80W90'                  ,'UN','P',5990,3800,4.66,34,7,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (18,'SYNPOWER FS 75W90 valvoline GEAR OIL'              ,'UN','P',12990,7800,6.80,25,10,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (19,'AGUA DESTILADA BOSQUE VERDE 5 LTS'                 ,'LT','P',2000,1000,NULL,200,20,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (20,'AGUA DESTILADA TRIBUNO 5 LTS'                      ,'LT','P',2500,1200,NULL,90,9,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (21,'AGUA DESTILADA TRIBUNO 1 LT'                       ,'LT','P',700,480,NULL,100,10,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (22,'CAMBIO PASTILLAS FRENO NISSAN V16'                 ,'UN','S',21900,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (23,'CAMBIO PASTILLAS FRENO TOYOTA YARIS'               ,'UN','S',25000,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (24,'CAMBIO PASTILLAS FRENO CHEVROLET CORSA'            ,'UN','S',27000,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (25,'CAMBIO PASTILLAS FRENO SUZUKI ALTO'                ,'UN','S',23990,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (26,'CAMBIO PASTILLAS FRENO SUZUKI MARUTI'              ,'UN','S',19900,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (27,'LAVADO DE CARROCERIA'                        ,'UN','S',10000,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (28,'LIMPIEZA DE INYECTORES'                      ,'UN','S',9000,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (29,'CAMBIO DE BUJIAS'                            ,'UN','S',18500,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (30,'FILTRO DE AIRE'                              ,'UN','S',5990,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (31,'LAVADO DE TAPIZ'                             ,'UN','S',15000,NULL,NULL,NULL,NULL,'N',1,NULL);


UPDATE PRODUCTO 
SET CODPRODUCTO_REL = 11
WHERE CODPRODUCTO <=9;

UPDATE PRODUCTO
SET CODPRODUCTO_REL = 27
WHERE (CODPRODUCTO >=22) AND (CODPRODUCTO <=26);

INSERT INTO PROMOCION VALUES (100,'FILTRO DE aceite GRATIS AMALIE',to_date('01-01-2017'),to_date('28-02-2017'),1,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (101,'FILTRO DE aceite GRATIS EDGE USA',to_date('01-01-2017'),to_date('30-05-2017'),2,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (102,'FILTRO DE aceite GRATIS CASTROL',to_date('01-01-2017'),to_date('30-05-2017'),3,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (103,'FILTRO DE aceite GRATIS LIQUI MOLY',to_date('01-01-2017'),to_date('30-05-2017'),4,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (104,'FILTRO DE aceite GRATIS HYUNDAI XTEER',to_date('01-01-2017'),to_date('30-05-2020'),5,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (105,'FILTRO DE aceite GRATIS MOBIL SUPER' ,to_date('01-01-2017'),to_date('30-05-2017'),6,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (106,'FILTRO DE aceite GRATIS ROYAL PURPLE',to_date('01-01-2017'),to_date('30-05-2020'),7,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (107,'FILTRO DE aceite GRATIS VALVOLINE',to_date('01-01-2017'),to_date('30-05-2020'),8,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (108,'FILTRO DE aceite GRATIS YPF ELAION',to_date('01-01-2017'),to_date('30-05-2020'),9,0,11,empty_blob());
INSERT INTO PROMOCION VALUES (109,'CAMBIO PASTILLA FRENO NISSAN V16, LAVADO GRATIS',to_date('01-01-2020'),to_date('30-05-2020'),22,0,27,empty_blob());
INSERT INTO PROMOCION VALUES (110,'CAMBIO PASTILLA FRENO TOYOTA YARIS, LAVADO GRATIS',to_date('01-01-2017'),to_date('30-05-2020'),23,0,27,empty_blob());
INSERT INTO PROMOCION VALUES (111,'CAMBIO PASTILLA FRENO CHEVROLET CORSA, LAVADO GRATIS',to_date('01-01-2017'),to_date('30-05-2018'),24,0,27,empty_blob());
INSERT INTO PROMOCION VALUES (112,'CAMBIO PASTILLA FRENO SUZUKI ALTO, LAVADO GRATIS'      ,to_date('01-01-2017'),to_date('30-05-2019'),25,0,27,empty_blob());
INSERT INTO PROMOCION VALUES (113,'CAMBIO PASTILLA FRENO SUZUKI MARUTI, LAVADO GRATIS',to_date('01-01-2017'),to_date('30-05-2020'),26,0,27,empty_blob());
update vendedor set nombre= upper(nombre), mail=upper(mail);


insert into factura values (11520,'6245678-1','12456778-1',to_date('02/01 /2020'),to_date('02/02 /2020'),100000,19000,119000,1,4,'178904', 'EM');
insert into factura values (11521,'7812354-2','10712354-2',to_date('02/01 /2020'),NULL,149000,28310,177310,NULL,1,NULL,'EM');
insert into factura values (11522,'9912478-3','12456778-1',to_date('03/02 /2020'),NULL,209400,39786,249186,2,3,NULL,'PA');
insert into factura values (11523,'14456789-4','11124678-3',to_date('04/02 /2020'),NULL,37500,7125,44625,NULL,1,NULL,'EM');
insert into factura values (11524,'11245678-5','11124678-3',to_date('15/02 /2020'),NULL,58455,11606,69561,2,4,NULL,'EM');
insert into factura values (11525,'6467708-6','12456778-1',to_date('16/02 /2020'),'16/03 /2020',30000,5700,35700,2,4,'8904865', 'EM');
insert into factura values (11526,'10125945-7','10456789-4',to_date('17/02 /2020'),NULL,29700,5643,35343,2,3,NULL,'PA');
insert into factura values (11527,'8125781-8','10712354-2',to_date('07/03 /2020'),NULL,29700,5643,35343,NULL,1,NULL,'EM');
insert into factura values (11528,'13746912-9','10712354-2',to_date('07/03 /2020'),NULL,29700,5643,35343,2,4,'CF-123647','EM');
insert into factura values (11529,'5446780-0','10456789-4',to_date('08/03 /2020'),NULL,21900,4161,26061,NULL,1,NULL,'EM');
insert into factura values (11530,'10812874-0','10456789-4',to_date('08/03 /2020'),NULL,27000,5130,32130,NULL,1,NULL,'EM');

INSERT INTO DETALLE_FACTURA VALUES (11520,1,25000,100,'FILTRO DE aceite GRATIS AMALIE',0,4,100000);
INSERT INTO DETALLE_FACTURA VALUES (11521,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_FACTURA VALUES (11521,19,2000,NULL,NULL,0,10,20000);
INSERT INTO DETALLE_FACTURA VALUES (11522,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_FACTURA VALUES (11522,16,6990,NULL,NULL,0,10,69900);
INSERT INTO DETALLE_FACTURA VALUES (11522,21,700,NULL,NULL,0,15,10500);
INSERT INTO DETALLE_FACTURA VALUES (11523,2,12500,101,'FILTRO DE aceite GRATIS EDGE USA',0,3,37500);
INSERT INTO DETALLE_FACTURA VALUES (11524,3,12990,null,null,50,6,58455);
INSERT INTO DETALLE_FACTURA VALUES (11525,15,10000,null,null,50,4,30000);
INSERT INTO DETALLE_FACTURA VALUES (11526,5,4950,104,'FILTRO DE aceite GRATIS HYUNDAI XTEER',0,6,29700);
INSERT INTO DETALLE_FACTURA VALUES (11527,5,4950,104,'FILTRO DE aceite GRATIS HYUNDAI XTEER',0,6,29700);
INSERT INTO DETALLE_FACTURA VALUES (11528,5,4950,104,'FILTRO DE aceite GRATIS HYUNDAI XTEER',0,6,29700);
INSERT INTO DETALLE_FACTURA VALUES (11529,22,21900,null,null,0,1,21900);
INSERT INTO DETALLE_FACTURA VALUES (11530,24,27000,null,null,0,1,27000);


insert into BOLETA values (120,'6245678-1','12456778-1',to_date('22/10/2020'),119000,1,4,'DS4344', 'EM');
insert into BOLETA values (121,'7812354-2','10712354-2',to_date('22/10/2020'),177310,NULL,1,NULL,'EM');
insert into BOLETA values (122,'9912478-3','12456778-1',to_date('23/10/2019'),249186,2,3,NULL,'PA');
insert into BOLETA values (123,'14456789-4','11124678-3',to_date('24/10/2019'),44625,NULL,1,NULL,'EM');
insert into BOLETA values (124,'11245678-5','11124678-3',to_date('25/10/2020'),69561,2,4,NULL,'EM');
insert into BOLETA values (125,'6467708-6','10456789-4',to_date('26/11/2020'),35700,2,4,'4865', 'EM');
insert into BOLETA values (126,'10125945-7','12456778-1',to_date('27/08/2020'),35343,2,3,NULL,'PA');
insert into BOLETA values (127,'8125781-8','10712354-2',to_date('17/10/2020'),35343,NULL,1,NULL,'EM');
insert into BOLETA values (128,'13746912-9','10456789-4',to_date('17/09/2020'),35343,2,4,'S/N 36147','EM');
insert into BOLETA values (129,'5446780-0','12456778-1',to_date('18/09/2020'),26061,NULL,1,NULL,'EM');
insert into BOLETA values (130,'10812874-0','10456789-4',to_date('18/10/2020'),32130,NULL,1,NULL,'EM');



INSERT INTO DETALLE_BOLETA VALUES (120,1,25000,100,'FILTRO DE aceite GRATIS AMALIE',0,4,100000);
INSERT INTO DETALLE_BOLETA VALUES (121,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_BOLETA VALUES (121,19,2000,NULL,NULL,0,10,20000);
INSERT INTO DETALLE_BOLETA VALUES (122,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_BOLETA VALUES (122,16,6990,NULL,NULL,0,10,69900);
INSERT INTO DETALLE_BOLETA VALUES (122,21,700,NULL,NULL,0,15,10500);
INSERT INTO DETALLE_BOLETA VALUES (123,2,12500,101,'FILTRO DE aceite GRATIS EDGE USA',0,3,37500);
INSERT INTO DETALLE_BOLETA VALUES (124,3,12990,null,null,50,6,58455);
INSERT INTO DETALLE_BOLETA VALUES (125,15,10000,null,null,50,4,30000);
INSERT INTO DETALLE_BOLETA VALUES (126,5,4950,104,'FILTRO DE aceite GRATIS HYUNDAI XTEER',0,6,29700);
INSERT INTO DETALLE_BOLETA VALUES (127,5,4950,104,'FILTRO DE aceite GRATIS HYUNDAI XTEER',0,6,29700);
INSERT INTO DETALLE_BOLETA VALUES (128,5,4950,104,'FILTRO DE aceite GRATIS HYUNDAI XTEER',0,6,29700);
INSERT INTO DETALLE_BOLETA VALUES (129,22,21900,null,null,0,1,21900);
INSERT INTO DETALLE_BOLETA VALUES (130,24,27000,null,null,0,1,27000);


commit;

