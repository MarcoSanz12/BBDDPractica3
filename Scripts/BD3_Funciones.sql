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

DROP FUNCTION IF EXISTS 
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


