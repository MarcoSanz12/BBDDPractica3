/* TRIGGER's */

/* I. Trigger alumno borrado a histórico */

DROP TRIGGER IF EXISTS TrAlumnoEliminar;

delimiter $$

CREATE TRIGGER alumnoEliminar
AFTER DELETE ON alumno
FOR EACH ROW
BEGIN
	
    IF (month(curdate()) < 9) THEN
		SET @anyoEscolar:= year(curdate());
	ELSE
		SET @anyoEscolar:=year(curdate()+1);
	END IF;
    
INSERT INTO AlumnoHistorico VALUES (
old.nombre,
old.apellido1,
old.telefono,
old.idCurso,
curdate(),
@anyoEscolar
);

END$$


delimiter ;

/* II. Evitar notas de exámenes o prácticas en el 3º Trimestre a los alumnos de 2º curso */
/*WORK IN PROGRESS*/


DROP TRIGGER IF EXISTS TrNotaComprobacion;

delimiter $$

CREATE TRIGGER TrNotaComprobacion
BEFORE INSERT ON nota
FOR EACH ROW
BEGIN

	SELECT c.anyo FROM curso c, modulo m WHERE c.id = m.idCurso AND m.id = new.idModulo INTO @anyo;
    
    SET @alumnoEnModulo:= FunComprobarAlumnoModulo(new.idAlumno,new.idModulo);
    
	/* Compruebo que el alumno este en el modulo */
    IF (@alumnoEnModulo = 0) THEN
    
    SIGNAL SQLSTATE '25999' SET MYSQL_ERRNO = 1452,
	MESSAGE_TEXT = 'ERROR! Dicho alumno no forma parte de ese modulo';
    
	/*Compruebo que un alumno de 2º curso/ 3er trimestre no tenga examenes o practicas */
    ELSEIF (new.evaluacion = 3 AND @anyo = 2 AND (new.tipo = 'examen' OR new.tipo = 'practica')) THEN
		
	SIGNAL SQLSTATE '23001' SET MYSQL_ERRNO = 1452,
	MESSAGE_TEXT = 'ERROR! No se pueden introducir notas de examen o practica en el 3er trimestre del 2º curso';
    
    /* Compruebo que un alumno de 2º curso/3er trimestre no tenga una nota ya de FCT*/
    ELSEIF (new.evaluacion = 3 AND @anyo = 2 AND (new.tipo = 'fct')) THEN
		
        SET @fct:=(SELECT count(*) FROM nota n WHERE n.idAlumno = new.idAlumno AND n.tipo = 'fct');

        IF (@fct > 0) THEN

            SIGNAL SQLSTATE '25998' SET MYSQL_ERRNO = 1452,
	        MESSAGE_TEXT = 'ERROR! El alumno ya tiene una nota guardada de FCT, eliminela antes de volver a insertar';
        END IF;

    /* Compruebo que un alumno de 2º curso/3er trimestre no tenga una nota ya de pryecto*/
     ELSEIF (new.evaluacion = 3 AND @anyo = 2 AND (new.tipo = 'proyecto')) THEN

        
        SET @proyecto:=(SELECT count(*) FROM nota n WHERE n.idAlumno = new.idAlumno AND n.tipo = 'proyecto');

        IF (@proyecto > 0) THEN

            SIGNAL SQLSTATE '25997' SET MYSQL_ERRNO = 1452,
	        MESSAGE_TEXT = 'ERROR! El alumno ya tiene una nota guardada de proyecto, eliminela antes de volver a insertar';

        END IF;

		
    /* Compruebo que un alumno de 2º curso/ 1er o 2º trimestre no tenga fct o proyecto */ 
    ELSEIF (new.evaluacion != 3 AND @anyo = 2 AND (new.tipo = 'fct' OR new.tipo = 'proyecto')) THEN
    
    SIGNAL SQLSTATE '23002' SET MYSQL_ERRNO = 1452,
	MESSAGE_TEXT = 'ERROR! No se pueden introducir notas de fct o proyecto fuera del 3er trimestre del 2º curso';
    
	/* Compruebo que un alumno de 1er curso no tenga fct o proyecto */ 
    ELSEIF (@anyo = 1 AND (new.tipo = 'fct' OR new.tipo = 'proyecto')) THEN
    
    SIGNAL SQLSTATE '23003' SET MYSQL_ERRNO = 1452,
	MESSAGE_TEXT = 'ERROR! No se pueden introducir notas de fct o proyecto fuera del 2º curso';

    /* Compruebo que la nota sea proyecto,fct,examen o practica */ 
    ELSEIF (new.tipo != 'fct' AND new.tipo != 'proyecto' AND new.tipo != 'examen' AND new.tipo != 'practica') THEN
     SIGNAL SQLSTATE '23003' SET MYSQL_ERRNO = 1452,
	MESSAGE_TEXT = 'ERROR! El tipo de nota introducido no es válido [fct, proyecto, examen, practica]';
    
    END IF;
	
END$$
delimiter ;


/* III. Evitar que un profesor tenga más de 25 horas lectivas semanales */

DELIMITER $$


CREATE TRIGGER TrExcesoTrabajo
BEFORE INSERT ON modulo
FOR EACH ROW
BEGIN

SET @horasAcumuladas = (SELECT sum(m.horas) FROM modulo m WHERE m.idProfesor = new.idProfesor);

IF (@horasAcumuladas + new.horas > 25) THEN

    SIGNAL SQLSTATE '23000' SET MYSQL_ERRNO = 1452,
	MESSAGE_TEXT = 'ERROR! El profesor asignado supera la cantidad de 25 horas permitidas';
    
END IF;

END$$

DELIMITER ;

/* IV. Evitar que haya más de 6 módulos por curso */

/* BEFORE INSERT */

    DROP TRIGGER IF EXISTS TrModulosMaximosBI

    DELIMITER $$

    CREATE TRIGGER TrModulosMaximosBI
    BEFORE INSERT ON modulo
    FOR EACH ROW
    BEGIN

    SET @cantidad:=(SELECT count(*) FROM modulo WHERE idCurso = new.idCurso);

    IF (@cantidad >= 6) THEN

    SIGNAL SQLSTATE '24000' SET MYSQL_ERRNO = 1452,
        MESSAGE_TEXT = 'ERROR! La cantidad de módulos en este curso es mayor a 6';
    END IF;
   

    END$$

    DELIMITER ;


    DELETE FROM modulo;

/* BEFORE UPDATE */

    DROP TRIGGER IF EXISTS TrModulosMaximosBU

    DELIMITER $$

    CREATE TRIGGER TrModulosMaximosBU
    BEFORE UPDATE ON modulo
    FOR EACH ROW
    BEGIN

    SET @cantidad:=(SELECT count(*) FROM modulo WHERE idCurso = new.idCurso);

    IF (@cantidad >= 6) THEN

    SIGNAL SQLSTATE '24000' SET MYSQL_ERRNO = 1452,
        MESSAGE_TEXT = 'ERROR! La cantidad de módulos en este curso es mayor a 6';
    END IF;
   

    END$$

    DELIMITER ;


    DELETE FROM modulo;

