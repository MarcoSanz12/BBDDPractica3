/* FASE PRUEBAS */

INSERT INTO PROFESOR VALUES(1,'Juan','Carlos','Mota'),
                            (2,'Pipo','Guierrez','Diaz');

INSERT INTO curso VALUES (1,'Desarrollo Aplicaciones Multiplataforma',1,'DAM1',1);
INSERT INTO curso VALUES (2,'Desarrollo Aplicaciones Multiplataforma',2,'DAM2',2);

INSERT INTO modulo VALUES (5,'Acceso a datos',2,2,2,2,2,10);

INSERT INTO nota (calificacion,tipo,evaluacion,idAlumno,idModulo) VALUES (10,'fct',2,1,1),


INSERT INTO modulo VALUES (1,'Programacion',1,1,2,2,2,10);
INSERT INTO modulo VALUES (2,'Programacion2',1,1,2,2,2,10);
INSERT INTO modulo VALUES (3,'Programacion2',1,1,2,2,2,5);
INSERT INTO modulo VALUES (4,'Programacion2',1,1,2,2,2,5);

INSERT INTO alumno VALUES (1,'Maria','Montes','Huete',15,'894738292','Calle pipo',1),
                        (2,'Tomás','Killian','Huete',12,'8394738292','Calle pipo 2',1);

INSERT INTO falta (idAlumno,idModulo,evaluacion) VALUES (1,1,2),(2,1,2),(2,1,2),(2,1,2),(2,1,2)

INSERT INTO nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
                  VALUES (8.8,'examen',2,1,1),
                         (9.8,'examen',2,1,1),
                         (7.5,'practica',2,1,1);


INSERT INTO nota (calificacion,tipo,evaluacion,idAlumno,idModulo)
                  VALUES (0.2,'examen',2,2,1),
                         (3.4,'examen',2,2,1),
                         (9.9,'practica',2,2,1);
                        

