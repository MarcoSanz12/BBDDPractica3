/* 1ª Interacción funcional para obtener la nota media para ser utilizado en el bucle for de calcularBoletin()*/

DROP FUNCTION prueba1
delimiter $$
CREATE FUNCTION prueba1 (curIdCurso INT)
RETURNS DOUBLE
BEGIN

		DECLARE modulosDone INTEGER DEFAULT 0;
        
		DECLARE nota DOUBLE;
        
        DECLARE curModId INT;
        
        DECLARE curModulos CURSOR FOR SELECT id FROM Modulo WHERE idCurso = curIdCurso;
        
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET modulosDone = 1;
        
        SET nota := 0.0;
       
        
        OPEN curModulos; 
        
    		modulos_loop: LOOP
        FETCH FROM curModulos INTO curModId;

            IF modulosDone = 1 THEN

				LEAVE modulos_loop;

            END IF; 

		   SET nota := nota + extraerNotaMedia(1,1,curIdCurso);
           
            

        END LOOP modulos_loop;
        CLOSE curModulos;
        
        
         SET nota := (nota / (SELECT count(*) FROM modulo WHERE idCurso = curIdCurso));
        return nota;
END$$

DELIMITER ;

