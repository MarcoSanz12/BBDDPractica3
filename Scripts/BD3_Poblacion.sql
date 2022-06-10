/* FASE PRUEBAS */

/* Creación profesor 1 y 2 */
INSERT INTO PROFESOR VALUES(1,'Jose','Antonio','Minguela');
INSERT INTO PROFESOR VALUES(2,'Chema','Mariez','Minguela');

/* Creación curso */

INSERT INTO Curso VALUES (1,'Desarrollo Aplicaciones Multiplataforma',1,'DAM',1);
INSERT INTO Curso VALUES (2,'Desarrollo Aplicaciones Multiplataforma',2,'DAM',2);


/* Creación modulos */

INSERT INTO Modulo VALUES (1,'Programación',1,1,5,5,5,1);
INSERT INTO Modulo VALUES (2,'Bases de datos',1,1,5,5,5,1);
INSERT INTO Modulo VALUES (3,'Entornos de desarrollo',1,1,5,5,5,1);

INSERT INTO Modulo VALUES (4,'Acceso a datos',1,2,5,5,5,1);
INSERT INTO Modulo VALUES (5,'Bases de Datos 2',1,2,5,5,5,1);
INSERT INTO Modulo VALUES (6,'Sistemas de desarrollo 2',1,1,5,5,5,1);

/* Creación alumno*/

INSERT INTO Alumno VALUES (1,'Juan','Diaz','Castillo',15,'35262629J','C/ Pipo 13',1);
INSERT INTO Alumno VALUES (2,'Marta','Diaz','Castillo',15,'35262628H','C/ Pipo 13',2);

/* Creación nota */

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',1,1,1);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',1,1,2);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',1,1,3);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (5.8,'practica',1,1,1);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (3.8,'practica',1,1,2);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (2.8,'practica',1,1,3);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',2,1,1);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',2,1,2);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',2,1,3);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (5.8,'practica',2,1,1);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (3.8,'practica',2,1,2);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (2.8,'practica',2,1,3);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',3,1,1);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',3,1,2);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',3,1,3);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (5.8,'practica',3,1,1);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (3.8,'practica',3,1,2);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (2.8,'practica',3,1,3);


INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',1,2,4);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',1,2,5);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',1,2,6);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'practica',1,2,4);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'practica',1,2,5);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'practica',1,2,6);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',2,2,4);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',2,2,5);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'examen',2,2,6);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'practica',2,2,4);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'practica',2,2,5);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'practica',2,2,6);

INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'fct',3,2,4);
INSERT INTO Nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
VALUES (8.8,'proyecto',3,2,5);
