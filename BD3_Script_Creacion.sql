DROP DATABASE IF EXISTS sanViator;
CREATE DATABASE sanViator;
USE sanViator;

/* Creación BBDD */

CREATE TABLE Profesor (

	id INT UNIQUE NOT NULL,
	nombre VARCHAR(96) NOT NULL,
	apellido1 VARCHAR(96) NOT NULL,
	apellido2 VARCHAR(96) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Curso (

	id INT UNIQUE NOT NULL,
	nombre VARCHAR(96) NOT NULL,
	anyo INT,
	siglas VARCHAR(8) NOT NULL,
	idProfesor INT UNIQUE NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (idProfesor) REFERENCES Profesor(id)

);

CREATE TABLE Modulo (

	id INT UNIQUE NOT NULL,
	nombre VARCHAR(96),
	idProfesor INT NOT NULL,
	idCurso INT NULL,
	limiteFaltas1 INT NOT NULL,
	limiteFaltas2 INT NOT NULL,
	limiteFaltas3 INT,
	horas INT,
	PRIMARY KEY (id),
	FOREIGN KEY (idProfesor) REFERENCES Profesor(id),
	FOREIGN KEY (idCurso) REFERENCES Curso(id)

);

CREATE TABLE Alumno (

	id INT UNIQUE NOT NULL,
	nombre VARCHAR(96) NOT NULL,
	apellido1 VARCHAR (96) NOT NULL,
	apellido2 VARCHAR (96),
	edad INT,
	telefono VARCHAR (96),
	direccion VARCHAR (96),
	idCurso INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (idCurso) REFERENCES curso(id)

);

CREATE TABLE Nota (

	id INT UNIQUE NOT NULL AUTO_INCREMENT,
	calificacion DOUBLE NOT NULL,
	tipo VARCHAR(96) NOT NULL, /*(examen, practica, fct, proyecto) */
	evaluacion INT NOT NULL, /*(1,2,3)*/
	idAlumno INT NOT NULL,
	idModulo INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (idModulo) REFERENCES modulo(id),
	FOREIGN KEY (idAlumno) REFERENCES alumno(id)
    
);

CREATE TABLE Falta (

	id INT UNIQUE NOT NULL AUTO_INCREMENT,
	idAlumno INT NOT NULL,
	idModulo INT NOT NULL,
	evaluacion INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (idModulo) REFERENCES modulo(id),
	FOREIGN KEY (idAlumno) REFERENCES alumno(id)

);

CREATE TABLE AlumnoHistorico (

	id INT UNIQUE NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(96) NOT NULL,
	apellido1 VARCHAR (96) NOT NULL,
	telefono VARCHAR (96),
	idCurso INT NOT NULL,
	fechaFin DATE NOT NULL,
	anyoAcademico INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (idCurso) REFERENCES curso(id)

);




