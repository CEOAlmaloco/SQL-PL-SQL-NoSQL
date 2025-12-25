-- creamos el package que va a tener las funciones de zona extrema y ranking tambien dejamos dos variables publicas q van a servir despues
CREATE OR REPLACE PACKAGE pkg_proceso_becas AS
    -- estas variables las usamos para guardar la fecha del proceso y contar cuantos se procesaron
    v_fecha_proceso DATE;
    v_total_procesados NUMBER := 0;
    
    -- funcion para sacar el puntaje de zona extrema
    FUNCTION fn_obt_ptje_zona_extrema(p_numrun IN NUMBER) RETURN NUMBER;
    
    -- funcion para sacar el puntaje por el ranking de la institucion
    FUNCTION fn_obt_ptje_ranking_inst(p_numrun IN NUMBER) RETURN NUMBER;
END pkg_proceso_becas;
/

CREATE OR REPLACE PACKAGE BODY pkg_proceso_becas AS
    
    -- aca va la implementacion de la funcion de zona extrema
    FUNCTION fn_obt_ptje_zona_extrema(p_numrun IN NUMBER) RETURN NUMBER IS
        v_ptje_zona NUMBER := 0;
        v_rutina_error VARCHAR2(250);
        v_mensaje_error VARCHAR2(250);
    BEGIN
        BEGIN
            -- joins para sacar el puntaje segun la zona extrema donde trabaja usamos nvl por si es null que retorne 0
            BEGIN
                SELECT 
                    NVL(pze.ptje_zona, 0)
                INTO v_ptje_zona
                FROM ANTECEDENTES_LABORALES al
                INNER JOIN SERVICIO_SALUD ss 
                ON al.cod_serv_salud = ss.cod_serv_salud
                LEFT JOIN PTJE_ZONA_EXTREMA pze 
                ON ss.zona_extrema = pze.zona_extrema
                WHERE al.numrun = p_numrun
                AND ROWNUM = 1;
            EXCEPTION 
                WHEN OTHERS THEN
                    v_ptje_zona := 0;
                    v_rutina_error := 'fn_obt_ptje_zona_extrema - error en select';
                    v_mensaje_error := SQLERRM;
                    BEGIN
                        INSERT INTO ERROR_PROCESO (numrun, rutina_error, mensaje_error)
                        VALUES (p_numrun, v_rutina_error, v_mensaje_error);
                    EXCEPTION 
                        WHEN OTHERS THEN 
                            NULL; 
                    END;
            END;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_ptje_zona := 0;
            WHEN OTHERS THEN
                v_ptje_zona := 0;
        END;
        RETURN v_ptje_zona;
    END fn_obt_ptje_zona_extrema;
    
    -- funcion para sacar el puntaje por ranking de la universidad
    FUNCTION fn_obt_ptje_ranking_inst(p_numrun IN NUMBER) RETURN NUMBER IS
        v_ptje_ranking NUMBER := 0;
        v_rutina_error VARCHAR2(250);
        v_mensaje_error VARCHAR2(250);
    BEGIN
        BEGIN
            -- buscamos el programa al que postulo, luego la institucion y su ranking,despues hacemos between para ver en que rango esta
            SELECT 
                pri.ptje_ranking
            INTO v_ptje_ranking
            FROM POSTULACION_PROGRAMA_ESPEC ppe
            INNER JOIN PROGRAMA_ESPECIALIZACION pe 
            ON ppe.cod_programa = pe.cod_programa
            INNER JOIN INSTITUCION i 
            ON pe.cod_inst = i.cod_inst
            INNER JOIN PTJE_RANKING_INST pri 
            ON i.ranking BETWEEN pri.rango_ranking_ini AND pri.rango_ranking_ter
            WHERE ppe.numrun = p_numrun;
        EXCEPTION 
            WHEN OTHERS THEN
                v_ptje_ranking := 0;
                v_rutina_error := 'fn_obt_ptje_ranking_inst - error en select';
                v_mensaje_error := SQLERRM;
                BEGIN
                    INSERT INTO ERROR_PROCESO (numrun, rutina_error, mensaje_error)
                    VALUES (p_numrun, v_rutina_error, v_mensaje_error);
                EXCEPTION 
                    WHEN OTHERS THEN 
                        NULL; 
                END;
        END;
        RETURN v_ptje_ranking;
    END fn_obt_ptje_ranking_inst;
    
END pkg_proceso_becas;
/

-- funcion para calcular el puntaje por horas trabajadas
CREATE OR REPLACE FUNCTION fn_obt_ptje_horas_trab
(p_numrun IN NUMBER) RETURN NUMBER IS
    v_total_horas NUMBER := 0;
    v_ptje_horas NUMBER := 0;
    v_rutina_error VARCHAR2(250);
    v_mensaje_error VARCHAR2(250);
BEGIN
    BEGIN
        -- sumamos todas las horas semanales porque puede trabajar en varios lados
        SELECT 
            SUM(horas_semanales)
        INTO v_total_horas
        FROM ANTECEDENTES_LABORALES
        WHERE numrun = p_numrun;
    EXCEPTION 
        WHEN OTHERS THEN
            v_total_horas := 0;
            v_rutina_error := 'fn_obt_ptje_horas_trab - error sumando horas';
            v_mensaje_error := SQLERRM;
            BEGIN
                INSERT INTO ERROR_PROCESO (numrun, rutina_error, mensaje_error)
                VALUES (p_numrun, v_rutina_error, v_mensaje_error);
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
    END;

    BEGIN
        -- luego buscamos en que rango cae el total de horas para asignar puntaje
        SELECT ptje_horas_trab
        INTO v_ptje_horas
        FROM PTJE_HORAS_TRABAJO
        WHERE v_total_horas BETWEEN rango_horas_ini AND rango_horas_ter;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_ptje_horas := 0;
            v_rutina_error := 'Error en fn_obt_ptje_horas_trab al obtener puntaje con horas de trabajo semanal: ' ||
            TO_CHAR(v_total_horas);
            v_mensaje_error := 'ORA-01403: No se ha encontrado ningun dato';
            BEGIN
                INSERT INTO ERROR_PROCESO (numrun, rutina_error, mensaje_error)
                VALUES (p_numrun, v_rutina_error, v_mensaje_error);
                COMMIT;
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
        WHEN OTHERS THEN
            v_ptje_horas := 0;
            v_rutina_error := 'fn_obt_ptje_horas_trab - error buscando rango';
            v_mensaje_error := SQLERRM;
            BEGIN
                INSERT INTO ERROR_PROCESO (numrun, rutina_error, mensaje_error)
                VALUES (p_numrun, v_rutina_error, v_mensaje_error);
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
    END;

    RETURN v_ptje_horas;
END fn_obt_ptje_horas_trab;
/

-- funcion para calcular puntaje por anios de experiencia
CREATE OR REPLACE FUNCTION fn_obt_ptje_annos_experiencia(
    p_numrun IN NUMBER,
    p_fecha_proceso IN DATE
) RETURN NUMBER IS
    v_fecha_contrato_antigua DATE;
    v_annos_experiencia NUMBER := 0;
    v_ptje_experiencia NUMBER := 0;
    v_rutina_error VARCHAR2(250);
    v_mensaje_error VARCHAR2(250);
BEGIN
    BEGIN
        -- buscamos la fecha de contrato mas antigua porque puede tener varios trabajos
        SELECT 
            MIN(fecha_contrato)
        INTO v_fecha_contrato_antigua
        FROM ANTECEDENTES_LABORALES
        WHERE numrun = p_numrun;
    EXCEPTION 
        WHEN OTHERS THEN
            v_fecha_contrato_antigua := p_fecha_proceso;
            v_rutina_error := 'fn_obt_ptje_annos_experiencia - error buscando fecha contrato';
            v_mensaje_error := SQLERRM;
            BEGIN
                INSERT INTO ERROR_PROCESO 
                (numrun, rutina_error, mensaje_error)
                VALUES 
                (p_numrun, v_rutina_error, v_mensaje_error);
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
    END;

    BEGIN
        -- calculamos los anios de experiencia
        v_annos_experiencia := EXTRACT(YEAR FROM p_fecha_proceso) - EXTRACT(YEAR FROM v_fecha_contrato_antigua);

        --luego buscamos el puntaje segun el rango de anios
        SELECT 
            ptje_experiencia
        INTO v_ptje_experiencia
        FROM PTJE_ANNOS_EXPERIENCIA
        WHERE v_annos_experiencia BETWEEN rango_annos_ini AND rango_annos_ter;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_ptje_experiencia := 0;
            v_rutina_error := 'Error en fn_obt_ptje_annos_experiencia al obtener puntaje con anos de experiencia: ' ||
            TO_CHAR(v_annos_experiencia);
            v_mensaje_error := 'ORA-01403: No se ha encontrado ningun dato';
            BEGIN
                INSERT INTO ERROR_PROCESO 
                (numrun, rutina_error, mensaje_error)
                VALUES 
                (p_numrun, v_rutina_error, v_mensaje_error);
                COMMIT;
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
        WHEN OTHERS THEN
            v_ptje_experiencia := 0;
            v_rutina_error := 'fn_obt_ptje_annos_experiencia - error buscando puntaje';
            v_mensaje_error := SQLERRM;
            BEGIN
                INSERT INTO ERROR_PROCESO 
                (numrun, rutina_error, mensaje_error)
                VALUES 
                (p_numrun, v_rutina_error, v_mensaje_error);
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
    END;

    RETURN v_ptje_experiencia;
END fn_obt_ptje_annos_experiencia;
/

-- este trigger es el que se dispara automaticamente cuando insertamos en detalle_puntaje_postulacion. lo q hace es calcula el puntaje final y determina si queda seleccionado o no
CREATE OR REPLACE TRIGGER trg_resultado_postulacion
AFTER INSERT ON DETALLE_PUNTAJE_POSTULACION
FOR EACH ROW
DECLARE
    v_ptje_final NUMBER;
    v_resultado VARCHAR2(20);
    v_rutina_error VARCHAR2(250);
    v_mensaje_error VARCHAR2(250);
BEGIN
    BEGIN
        -- sumamos todos los puntajes para sacar el total y dsp usamos :NEW para acceder a los valores que se acaban de insertar
        v_ptje_final := :NEW.ptje_annos_exp + :NEW.ptje_horas_trab + :NEW.ptje_zona_extrema + 
                        :NEW.ptje_ranking_inst + :NEW.ptje_extra_1 + :NEW.ptje_extra_2;

        -- si saco 4500 o mas esta seleccionado, sino no. criterio que define quien pasa 
        IF v_ptje_final >= 4500 THEN
            v_resultado := 'SELECCIONADO';
        ELSE
            v_resultado := 'NO SELECCIONADO';
        END IF;

        -- insertamos en la tabla de resultados con el run, puntaje y resultado-esta tabla es la que va a tener el resumen final de quien quedo o no
        BEGIN
            INSERT INTO RESULTADO_POSTULACION 
            (run_postulante, ptje_final_post, resultado_post)
            VALUES 
            (:NEW.run_postulante, v_ptje_final, v_resultado);
        EXCEPTION 
            WHEN OTHERS THEN
                v_rutina_error := 'trg_resultado_postulacion - error insertando resultado';
                v_mensaje_error := SQLERRM;
                BEGIN
                    INSERT INTO ERROR_PROCESO 
                    (numrun, rutina_error, mensaje_error)
                    VALUES 
                    (0, v_rutina_error, v_mensaje_error);
                EXCEPTION 
                    WHEN OTHERS THEN 
                        NULL; 
                END;
        END;
    EXCEPTION 
        WHEN OTHERS THEN
            v_rutina_error := 'trg_resultado_postulacion - error general';
            v_mensaje_error := SQLERRM;
            BEGIN
                INSERT INTO ERROR_PROCESO 
                (numrun, rutina_error, mensaje_error)
                VALUES 
                (0, v_rutina_error, v_mensaje_error);
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
    END;
END;
/

-- procedimiento principal que procesa todos los postulantes
CREATE OR REPLACE PROCEDURE sp_procesar_becas(
    p_fecha_proceso IN DATE,
    p_porc_extra_1 IN NUMBER,
    p_porc_extra_2 IN NUMBER
) IS
    -- variables para guardar la info que vamos a insertar
    v_run_formateado VARCHAR2(13);
    v_nombre_completo VARCHAR2(60);
    v_ptje_annos NUMBER;
    v_ptje_horas NUMBER;
    v_ptje_zona NUMBER;
    v_ptje_ranking NUMBER;
    v_ptje_extra_1 NUMBER;
    v_ptje_extra_2 NUMBER;
    v_suma_base NUMBER;
    v_edad NUMBER;
    v_total_horas NUMBER;
    v_annos_experiencia NUMBER;
    v_fecha_contrato_antigua DATE;
    v_rutina_error VARCHAR2(250);
    v_mensaje_error VARCHAR2(250);

    -- cursor para recorrer todos los postulantes que hicieron postulacion
    -- hacemos distinct por si acaso hay duplicados y traemos todos los datos personales que vamos a necesitar
    CURSOR cur_postulantes IS
        SELECT DISTINCT 
        ap.numrun, ap.dvrun, 
        ap.pnombre, ap.snombre, 
        ap.apaterno, ap.amaterno,
        ap.fecha_nacimiento
        FROM ANTECEDENTES_PERSONALES ap
        INNER JOIN POSTULACION_PROGRAMA_ESPEC ppe 
        ON ap.numrun = ppe.numrun
        ORDER BY ap.numrun;
BEGIN
    BEGIN
        -- guardamos la fecha en la variable del package para usarla despues
        pkg_proceso_becas.v_fecha_proceso := p_fecha_proceso;
        pkg_proceso_becas.v_total_procesados := 0;

        -- limpiamos las tablas antes de empezar para que no queden datos viejos
        EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_PUNTAJE_POSTULACION';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ERROR_PROCESO';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE RESULTADO_POSTULACION';
    EXCEPTION 
        WHEN OTHERS THEN
            v_rutina_error := 'sp_procesar_becas - error truncando tablas';
            v_mensaje_error := SQLERRM;
            BEGIN 
                INSERT INTO ERROR_PROCESO 
                (numrun, rutina_error, mensaje_error)
                VALUES 
                (0, v_rutina_error, v_mensaje_error); 
            EXCEPTION 
                WHEN OTHERS THEN 
                    NULL; 
            END;
    END;

    -- recorremos cada postulante
    FOR rec IN cur_postulantes LOOP
        BEGIN
            -- 12.345.678-9 ltrim para  los espacios en blanco del inicio
            v_run_formateado := LTRIM(TO_CHAR(rec.numrun, '999G999G999')) || '-' || UPPER(rec.dvrun);

            -- armamos el nombre completo con todos los datos si tiene segundo nombre lo agregamos, sino solo va primer nombre
            IF rec.snombre IS NOT NULL THEN
                v_nombre_completo := UPPER(rec.pnombre || ' ' || rec.snombre || ' ' || 
                                          rec.apaterno || ' ' || rec.amaterno);
            ELSE
                v_nombre_completo := UPPER(rec.pnombre || ' ' || rec.apaterno || ' ' || rec.amaterno);
            END IF;

            -- llamamos a las funciones para obtener los 4 puntajes base
            -- cada funcion se encarga de buscar su puntaje y manejar errores si los hay
            v_ptje_annos := fn_obt_ptje_annos_experiencia(rec.numrun, p_fecha_proceso);
            v_ptje_horas := fn_obt_ptje_horas_trab(rec.numrun);
            v_ptje_zona := pkg_proceso_becas.fn_obt_ptje_zona_extrema(rec.numrun);
            v_ptje_ranking := pkg_proceso_becas.fn_obt_ptje_ranking_inst(rec.numrun);

            -- sumamos los 4 puntajes base porque los extras se calculan sobre esta suma la q vamos a usar mas adelante para los porcentajes
            v_suma_base := v_ptje_annos + v_ptje_horas + v_ptje_zona + v_ptje_ranking;

            -- calculamos la edad usando months_between y lo redondeamos hacia abajo con floor para q de bien los anios
            v_edad := FLOOR(MONTHS_BETWEEN(p_fecha_proceso, rec.fecha_nacimiento) / 12);

            -- sumamos todas las horas que trabaja en todos sus trabajos y cmo puede chambear en varios lados entonces sumamos todo
            BEGIN
                SELECT 
                    SUM(horas_semanales)
                INTO v_total_horas
                FROM ANTECEDENTES_LABORALES
                WHERE numrun = rec.numrun;
            EXCEPTION 
                WHEN OTHERS THEN
                    -- si hay error le ponemos 0 horas
                    v_total_horas := 0;
            END;

            -- sacamos la fecha de contrato mas antigua para calcular experiencia y cmo puede tener varios contratos entonces agarramos el mas viejo
            BEGIN
                SELECT 
                    MIN(fecha_contrato)
                INTO v_fecha_contrato_antigua
                FROM ANTECEDENTES_LABORALES
                WHERE numrun = rec.numrun;
            EXCEPTION 
                WHEN OTHERS THEN
                    -- si falla le ponemos la fecha de proceso
                    v_fecha_contrato_antigua := p_fecha_proceso;
            END;

            -- calculamos anios de experiencia restando los anios y  usamos extract year para sacar solo el anio y restar
            v_annos_experiencia := EXTRACT(YEAR FROM p_fecha_proceso) - EXTRACT(YEAR FROM v_fecha_contrato_antigua);

            -- puntaje extra 1: se da si tiene menos de 45 anos y trabaja mas de 30 horas
            -- aca verificamos ambas condiciones con AND
            IF v_edad < 45 AND v_total_horas > 30 THEN
                -- le damos el 30% de la suma base y redondeamos
                v_ptje_extra_1 := ROUND(v_suma_base * p_porc_extra_1);
            ELSE
                -- si no cumple las condiciones el puntaje es 0
                v_ptje_extra_1 := 0;
            END IF;

            -- puntaje extra 2: se da si tiene mas de 25 anos de experiencia
            IF v_annos_experiencia > 25 THEN
                -- le damos el 15% de la suma base y redondeamos
                v_ptje_extra_2 := ROUND(v_suma_base * p_porc_extra_2);
            ELSE
                -- si no cumple la condicion el puntaje es 0
                v_ptje_extra_2 := 0;
            END IF;

            -- insertamos en la tabla de detalle con todos los puntajes calculados donde este insert va a disparar el trigger que genera el resultado final
            BEGIN
                INSERT INTO DETALLE_PUNTAJE_POSTULACION (
                    run_postulante, nombre_postulante,
                    ptje_annos_exp, ptje_horas_trab,
                    ptje_zona_extrema, ptje_ranking_inst,
                    ptje_extra_1, ptje_extra_2
                ) VALUES (
                    v_run_formateado, v_nombre_completo,
                    v_ptje_annos, v_ptje_horas,
                    v_ptje_zona, v_ptje_ranking,
                    v_ptje_extra_1, v_ptje_extra_2
                );
            EXCEPTION 
                WHEN OTHERS THEN
                    -- si falla el insert lo registramos en errores
                    v_rutina_error := 'sp_procesar_becas - error insertando detalle';
                    v_mensaje_error := SQLERRM;
                    BEGIN 
                        INSERT INTO ERROR_PROCESO 
                        (numrun, rutina_error, mensaje_error)
                        VALUES 
                        (rec.numrun, v_rutina_error, v_mensaje_error); 
                    EXCEPTION 
                        WHEN OTHERS THEN 
                            -- si falla el insert de error no hacemos nada
                            NULL; 
                    END;
            END;

            -- vamos contando cuantos postulantes procesamos exitosamente
            pkg_proceso_becas.v_total_procesados := pkg_proceso_becas.v_total_procesados + 1;

        EXCEPTION 
            WHEN OTHERS THEN
                v_rutina_error := 'sp_procesar_becas - error general por postulante';
                v_mensaje_error := SQLERRM;
                BEGIN 
                    INSERT INTO ERROR_PROCESO 
                    (numrun, rutina_error, mensaje_error)
                    VALUES 
                    (rec.numrun, v_rutina_error, v_mensaje_error); 
                EXCEPTION 
                    WHEN OTHERS THEN 
                        NULL; 
                END;
        END;
    END LOOP;

    -- guardamos todos los cambios con commit
    COMMIT;

    -- mostramos mensaje de exito con el total procesado para verlo en consola y evitar ver cada uno
    DBMS_OUTPUT.PUT_LINE('Proceso completado. Total postulantes procesados: ' || pkg_proceso_becas.v_total_procesados);

EXCEPTION
    WHEN OTHERS THEN
        -- si algo falla hacemos rollback para volver atras todos los cambios
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en procedimiento principal: ' || SQLERRM);
        RAISE;
END sp_procesar_becas;
/

-- ejecutamos el proceso con la fecha del 30 de junio de 2025
-- pasamos 0.30 para el 30% del puntaje extra 1
-- pasamos 0.15 para el 15% del puntaje extra 2
SET SERVEROUTPUT ON;
BEGIN
    sp_procesar_becas(TO_DATE('30/06/2025', 'DD/MM/YYYY'), 0.30, 0.15);
END;
/

-- consultas de resultados para ver que todo haya quedado bien
-- primero vemos si hubo errores
SELECT * FROM ERROR_PROCESO ORDER BY numrun;
-- luego vemos el detalle de puntajes de todos los postulantes
SELECT * FROM DETALLE_PUNTAJE_POSTULACION ORDER BY run_postulante;
-- y luego vemos quien quedo seleccionado y quien no sino pAJUERA
SELECT * FROM RESULTADO_POSTULACION ORDER BY run_postulante;
