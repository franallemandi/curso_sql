
-- SCRIPT ENTREGA 2 - Franco Allemandi


-- USAR BASE DE DATOS
USE moviesData;


-- VISTAS


-- Vista 1: Películas Populares
CREATE OR REPLACE VIEW vista_peliculas_populares AS
SELECT title, popularity
FROM movie
WHERE popularity > 80
ORDER BY popularity DESC;

-- Vista 2: 50 Películas con mayor Presupuesto
CREATE OR REPLACE VIEW vista_peliculas_mayor_presupuesto AS
SELECT title, budget
FROM movie
ORDER BY budget DESC LIMIT 50;

-- Vista 3: Recaudación por País
CREATE OR REPLACE VIEW vista_recaudacion_pais AS
SELECT c.country, SUM(m.revenue) AS total_revenue
FROM movie m
JOIN country c ON m.id_country = c.id_country
GROUP BY c.country
ORDER BY total_revenue DESC;

-- Vista 4: Películas, Compañía y Género
CREATE OR REPLACE VIEW vista_peliculas_compania_genero AS
SELECT m.title, c.company_name, g.genre
FROM movie m
JOIN company c ON m.id_company = c.id_company
JOIN genre g ON m.id_genre = g.id_genre;

-- Vista 5: Cantidad de Películas por Idioma
CREATE OR REPLACE VIEW vista_cantidad_peliculas_idioma AS
SELECT  l.language, COUNT(DISTINCT m.id_movie) AS cantidad
FROM movie m
JOIN language l ON m.id_language = l.id_language
GROUP BY l.language ORDER BY cantidad DESC;


-- FUNCIONES


DELIMITER //

-- Función 1: Calcular Rentabilidad
CREATE FUNCTION calcular_rentabilidad(p_id_movie INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
  DECLARE rentabilidad FLOAT;
  SELECT ((revenue - budget) / budget) * 100
  INTO rentabilidad
  FROM movie
  WHERE id_movie = p_id_movie;
  RETURN rentabilidad;
END;
//

-- Función 2: Total de votos por género
CREATE FUNCTION votos_totales_por_genero(p_id_genero INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total_votos INT;
  SELECT SUM(vote_count)
  INTO total_votos
  FROM movie
  WHERE id_genre = p_id_genero;
  RETURN total_votos;
END;
//

DELIMITER ;


-- STORED PROCEDURES


DELIMITER //

-- SP 1: Insertar nueva película
CREATE PROCEDURE insertar_pelicula(
  IN p_title VARCHAR(100), IN p_runtime INT, IN p_release_date DATE,
  IN p_popularity FLOAT, IN p_budget INT, IN p_revenue INT, IN p_vote_count INT,
  IN p_id_genre INT, IN p_id_country INT, IN p_id_company INT, IN p_id_language INT
)
BEGIN
  INSERT INTO movie(title, runtime, release_date, popularity, budget, revenue, vote_count,
    id_genre, id_country, id_company, id_language)
  VALUES (p_title, p_runtime, p_release_date, p_popularity, p_budget, p_revenue, p_vote_count,
    p_id_genre, p_id_country, p_id_company, p_id_language);
END;
//

-- SP 2: Actualizacion de cantidad de votos
CREATE PROCEDURE actualizar_votos(IN p_id_movie INT, IN cantidad INT)
BEGIN
  DECLARE votos_actuales INT;
  DECLARE nuevos_votos INT;
  
  SELECT vote_count
  INTO votos_actuales
  FROM movie
  WHERE id_movie=p_id_movie;
  SET nuevos_votos = votos_actuales + cantidad;
  
  UPDATE movie 
  SET vote_count = nuevos_votos
  WHERE id_movie=p_id_movie;
END;
//

DELIMITER ;


-- TRIGGERS


-- Tabla auxiliar para log de presupuesto
CREATE TABLE IF NOT EXISTS log_presupuesto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_movie INT,
  accion VARCHAR(50),
  budget INT,
  fecha DATETIME
);

DELIMITER //

-- Trigger 1: Registrar películas con alto presupuesto en INSERT
CREATE TRIGGER presupuesto_alto_insert
AFTER INSERT ON movie
FOR EACH ROW
BEGIN
  IF NEW.budget > 100000000 THEN
    INSERT INTO log_presupuesto(id_movie, accion, budget, fecha)
    VALUES (NEW.id_movie, 'INSERT', NEW.budget, NOW());
  END IF;
END;
//

-- Trigger 2: Registrar películas con alto presupuesto en UPDATE
CREATE TRIGGER presupuesto_alto_update
BEFORE UPDATE ON movie
FOR EACH ROW
BEGIN
  IF NEW.budget > 100000000 THEN
    INSERT INTO log_presupuesto(id_movie, accion, budget, fecha)
    VALUES (NEW.id_movie, 'UPDATE', NEW.budget, NOW());
  END IF;
END;
//

DELIMITER ;