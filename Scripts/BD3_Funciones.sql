/* FUNCIONES Y PROCEDIMIENTOS */

/* I. Comprobar si un alumno ha superado las faltas del módulo y evaluación */
/*OPERATIVO*/

DROP FUNCTION IF EXISTS superaFaltas;
delimiter $$
CREATE FUNCTION superaFaltas(pIdAlumno INT, pEvaluacion INT, pIdModulo INT)
RETURNS BOOLEAN
BEGIN

DECLARE supera BOOLEAN;

SET supera := FALSE;



SET @faltas:= (SELECT count(f.idalumno) FROM falta f WHERE f.idAlumno = pIdAlumno AND f.evaluacion = pEvaluacion AND f.idModulo = pIdModulo);

 IF (pEvaluacion = 1) THEN

	SET @limite:=(SELECT m.limiteFaltas1 FROM modulo m WHERE m.id = pIdModulo);

ELSEIF (pEvaluacion = 2) THEN

	SET @limite:=(SELECT m.limiteFaltas2 FROM modulo m WHERE m.id = pIdModulo);

ELSEIF (pEvaluacion = 3) THEN

	SET @limite:=(SELECT m.limiteFaltas3 FROM modulo m WHERE m.id = pIdModulo);

END IF;


IF (@faltas > @limite) THEN

	SET supera:=TRUE;

END IF; 

RETURN supera;


END$$

delimiter ;




/* II. Extraer el truncado de nota en texto */

DROP FUNCTION IF EXISTS truncadoNotaTexto;
delimiter $$
CREATE FUNCTION truncadoNotaTexto(nota DOUBLE)
RETURNS VARCHAR(96)
BEGIN

	DECLARE notaTexto VARCHAR(96);
    SET notaTexto := 'INSUFICIENTE';
    
    IF (nota >= 5 AND nota < 6.5) THEN
		SET notaTexto:='BIEN';
	ELSEIF (nota >= 6.5 AND nota < 8.5) THEN
		SET notaTexto:='NOTABLE';
	ELSEIF (nota>=8.5 AND nota < 9.5) THEN
		SET notaTexto:='SOBRESALIENTE';
	ELSEIF (nota>=9.5) THEN
		SET notaTexto:='MATRICULA DE HONOR';
	END IF;
    
    RETURN notaTexto;

END$$

delimiter ;

/* III. Extraer el truncado de nota en numero */

DROP FUNCTION IF EXISTS truncadoNotaNumero;
delimiter $$
CREATE FUNCTION truncadoNotaNumero(nota DOUBLE)
RETURNS INT
BEGIN

	DECLARE notaNumero INT;

    IF (nota >= 0 AND nota < 1) THEN
		SET notaNumero:=0;
	ELSEIF (nota >= 1 AND nota < 2) THEN
		SET notaNumero:=1;
	ELSEIF (nota>=2 AND nota < 3) THEN
		SET notaNumero:=2;
	ELSEIF (nota>=3 AND nota < 4) THEN
		SET notaNumero:=3;
	ELSEIF (nota>=4 AND nota < 5) THEN
		SET notaNumero:=4;
	ELSEIF (nota>=5 AND nota < 5.5) THEN
		SET notaNumero:=5;
	ELSEIF (nota>=5.5 AND nota < 6.5) THEN
		SET notaNumero:=6;
	ELSEIF (nota>=6.5 AND nota < 7.5) THEN
		SET notaNumero:=7;
	ELSEIF (nota>=7.5 AND nota < 8.5) THEN
		SET notaNumero:=8;
	ELSEIF (nota>=8.5 AND nota < 9.5) THEN
		SET notaNumero:=9;
	ELSE
		SET notaNumero:=10;
	END IF;
    
    RETURN notaNumero;

END$$

delimiter ;



/* IV. Extraer nota media de determinada evaluación */
/*OPERATIVO*/

DROP FUNCTION IF EXISTS extraerNotaMedia;
delimiter $$
CREATE FUNCTION extraerNotaMedia(pIdAlumno INT, pEvaluacion INT,pIdModulo INT)
RETURNS DOUBLE
BEGIN

	DECLARE notaMedia DOUBLE;
    
	SET notaMedia:=1;
      
    SET @superaFaltas := superaFaltas(pIdAlumno,pEvaluacion,pIdModulo);
 
	IF ( @superaFaltas = 1 ) THEN
		
		SET notaMedia:=(SELECT avg(n.calificacion) FROM nota n 
		WHERE n.idAlumno = pIdAlumno AND n.tipo = 'examen' AND n.evaluacion = pEvaluacion AND n.idModulo = pIdModulo);
	
	
	ELSE

		SET @notaMediaExamen:=(SELECT avg(n.calificacion) FROM nota n 
		WHERE n.idAlumno = pIdAlumno AND n.tipo = 'examen' AND n.evaluacion = pEvaluacion AND n.idModulo = pIdModulo);

		SET @notaMediaPractica:=(SELECT avg(n.calificacion) FROM nota n 
		WHERE n.idAlumno = pIdAlumno AND n.tipo = 'practica' AND n.evaluacion = pEvaluacion AND n.idModulo = pIdModulo);

		SET notaMedia:=(@notaMediaExamen + @notaMediaPractica)/2;

	END IF;
   

	RETURN notaMedia; 

END$$

delimiter ;

/* V. Comprobar si un alumno se encuentra en un determinado modulo */

DROP FUNCTION IF EXISTS FunComprobarAlumnoModulo
delimiter $$
CREATE FUNCTION FunComprobarAlumnoModulo (PidAlumno INT,PidModulo INT)
RETURNS BOOLEAN
BEGIN
DECLARE inside BOOLEAN;
SET inside:=FALSE;

SET @ocurrencias:=(SELECT count(*) FROM alumno a,modulo m WHERE a.id = PidAlumno AND m.id = PidModulo AND a.idCurso = m.idCurso);

IF (@ocurrencias > 0) THEN

SET inside := TRUE;

END IF;

RETURN inside;

END$$

delimiter ;

/* VI. Actualizar boletines DEPRECATED */

DROP FUNCTION IF EXISTS actualizarBoletin
delimiter $$
CREATE FUNCTION actualizarBoletin ()
RETURNS INT
BEGIN

DECLARE contador INT;

DECLARE alumnosTotales INT;

DECLARE curId INT;
DECLARE curIdCurso INT;
DECLARE curNombre VARCHAR (96);
DECLARE curCurso VARCHAR (96);
DECLARE curAnyo INT;

DECLARE curNotaE1 DOUBLE;
DECLARE curNotaE2 DOUBLE;
DECLARE curNotaE3 DOUBLE;
DECLARE curNotaF DOUBLE;

DECLARE curTextoE1 VARCHAR(96);
DECLARE curTextoE2 VARCHAR(96);
DECLARE curTextoE3 VARCHAR(96);
DECLARE curTextoF VARCHAR(96);

DECLARE curModId INT;

DECLARE curFct DOUBLE;
DECLARE curProyecto DOUBLE;


DECLARE var_final,modulosDone INTEGER DEFAULT 0;


DECLARE cursor1 CURSOR FOR SELECT a.id,a.idCurso,a.nombre,c.nombre,c.anyo FROM Alumno a, Curso c WHERE a.idCurso = c.id;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;

SET contador := 0;

OPEN cursor1;

  bucle: LOOP

 	FETCH cursor1 INTO curId,curIdCurso,curNombre,curCurso,curAnyo;

IF var_final = 1 THEN
      LEAVE bucle;
END IF;


BLOQUE_1: BEGIN
        DECLARE curModulos CURSOR FOR SELECT id FROM Modulo WHERE idCurso = curIdCurso;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET modulosDone = 1;
        
        OPEN curModulos; 
    		modulos_loop: LOOP
        FETCH FROM curModulos INTO curModId;

            IF modulosDone = 1 THEN

				LEAVE modulos_loop;

            END IF; 

		   SET @notaE1total := notaE1total + extraerNotaMedia(curId,1,curModId);

        END LOOP modulos_loop;
        END BLOQUE_1;

	BLOQUE_2: BEGIN
        DECLARE curModulos CURSOR FOR SELECT id FROM Modulo WHERE idCurso = curIdCurso;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET modulosDone = 1;
        OPEN curModulos; 
    		modulos_loop: LOOP
        FETCH FROM curModulos INTO curModId;   
            IF modulosDone = 1 THEN

				LEAVE modulos_loop;

            END IF; 

		   SET @notaE2total := notaE2total + extraerNotaMedia(curId,2,curModId);

        END LOOP modulos_loop;

        END BLOQUE_2;

IF (curAnyo = 1) THEN
	
	BLOQUE_3: BEGIN
        DECLARE curModulos CURSOR FOR SELECT id FROM Modulo WHERE idCurso = curIdCurso;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET modulosDone = 1;
        OPEN curModulos; 
    		modulos_loop: LOOP
        FETCH FROM curModulos INTO curModId;   
            IF modulosDone = 1 THEN

				LEAVE modulos_loop;

            END IF; 

		   SET @notaE3total := notaE3total + extraerNotaMedia(curId,3,curModId);

        END LOOP modulos_loop;
        END BLOQUE_3;


		SET @notaE3total := (@notaE3total / (SELECT count(distinct(id)) FROM Modulo WHERE idCurso = curIdCurso));

		SET curNotaE3 := truncadoNotaNumero(@notaE3total);
		SET curTextoE3 := truncadoNotaTexto(@notaE3total);
END IF;

		SET @notaE1total := (@notaE1total / (SELECT count(distinct(id)) FROM Modulo WHERE idCurso = curIdCurso));

		SET curNotaE1 := truncadoNotaNumero(@notaE1total);
		SET curTextoE1 := truncadoNotaTexto(@notaE1total);

		SET @notaE2total := (@notaE2total / (SELECT count(distinct(id)) FROM Modulo WHERE idCurso = curIdCurso));

		SET curNotaE2 := truncadoNotaNumero(@notaE2total);
		SET curTextoE2 := truncadoNotaTexto(@notaE2total);

		SET @notaFinalBruta := ((@notaE1total + @notaE2total + @notaE3total)/3);

		SET curNotaF := truncadoNotaNumero(@notaFinalBruta);
		SET curTextoF := truncadoNotaTexto(@notaFinalBruta);

		IF (curAnyo = 2) THEN
			SET curFct := (SELECT calificacion FROM Nota WHERE idAlumno = curId AND tipo = 'fct');
			SET curProyecto := (SELECT calificacion FROM Nota WHERE idAlumno = curId AND tipo = 'proyecto');
		END IF;

	IF ((SELECT count(*) FROM Boletin WHERE idAlumno = curId) > 0) THEN
		
		UPDATE Boletin SET idAlumno = curId, nombre = curNombre, curso = curCurso, anyo = curAnyo, notaE1 = curNotaE1, textoE1 = curTextoE1, notaE2 = curNotaE2, textoE2 = curTextoE2, notaE3 = curNotaE3, textoE3 = curTextoE3, notaF = curNotaF, textoF = curTextoF, fct = curFct, proyecto = curProyecto WHERE idAlumno = curId;

		SET contador := contador + 1;
		
	ELSE
		INSERT INTO Boletin VALUES (curId,curNombre,curCurso,curAnyo,curNotaE1,curTextoE1,curNotaE2,curTextoE2,curNotaE3,curTextoE3,curNotaF,curTextoF,curFct,curProyecto);

		SET contador := contador + 1;
	END IF;

END LOOP bucle;
 CLOSE cursor1;

 RETURN contador;



END$$

delimiter ;




