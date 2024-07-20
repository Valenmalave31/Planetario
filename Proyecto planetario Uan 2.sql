CREATE DATABASE PlanetarioUAN;
USE PlanetarioUAN;

CREATE TABLE Planetario (
    id_planetario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    pais VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL
);

CREATE TABLE Sistema_Solar (
    id_sistemaSolar INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    numero_planetas INT NOT NULL,
    id_planetario INT NOT NULL,
    FOREIGN KEY (id_planetario) REFERENCES Planetario(id_planetario)
);

CREATE TABLE Planeta (
    id_planeta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    periodo_orbital DECIMAL(20, 10) NOT NULL,
    velocidad_orbital DECIMAL(20, 10) NOT NULL,
    inclinacion_orbital DECIMAL(20, 10) NOT NULL,
    excentricidad DECIMAL(20, 10) NOT NULL,
    distancia_sol DECIMAL(20, 10) NOT NULL,
    id_sistemaSolar INT NOT NULL,
    FOREIGN KEY (id_sistemaSolar) REFERENCES Sistema_Solar(id_sistemaSolar)
);

CREATE TABLE Satelite (
    id_satelite INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    periodo_orbital DECIMAL (20,10) NOT NULL,
    inclinacion_orbital DECIMAL (20,10) NOT NULL,
    excentricidad DECIMAL (20,10) NOT NULL,
    planeta_satelite VARCHAR(50) NOT NULL,
    tipo_satelite ENUM('Artificial', 'Natural') NOT NULL,
    id_planeta INT NOT NULL,
    FOREIGN KEY (id_planeta) REFERENCES Planeta(id_planeta)
);

INSERT INTO Satelite (nombre, periodo_orbital, inclinacion_orbital, excentricidad, planeta_satelite, tipo_satelite, id_planeta)
VALUES	
    ('Luna', '27.3', '0.32', '21', 'Tierra', 'Natural', '3');

SELECT * FROM Satelite;

INSERT INTO Planetario (nombre, pais, ciudad) 
VALUES
    ('Galileo Galilei', 'Argentina', 'Buenos Aires'),
    ('Hemisfèric', 'España', 'Valencia'),
    ('Supernova', 'Alemania', 'Munich'),
    ('H.R. MacMillan Space Center', 'Canadá', 'Vancouver'),
    ('Albert Einstein Planetarium', 'Estados Unidos', 'Washington');

SELECT * FROM Planetario;

INSERT INTO Sistema_Solar (nombre, numero_planetas, id_planetario) 
VALUES
    ('Vía Láctea', 8, 1),
    ('55 Cancri', 5, 2),
    ('Gliese 581', 3, 3),
    ('Kepler-11', 6, 4),
    ('Epsilon Eridani', 1, 5);
    
SELECT * FROM Sistema_Solar;

INSERT INTO Planeta (nombre, periodo_orbital, velocidad_orbital, inclinacion_orbital, excentricidad, distancia_sol, id_sistemaSolar) 
VALUES
    ('Mercurio', 88, 47.87, 7.0, 0.2056, 57000000, 1),
    ('Venus', 224.7, 35.02, 3.4, 0.007, 108000000, 1),
    ('Tierra', 365.25, 29.78, 0.0, 0.0167, 149600000, 1),
    ('Marte', 687, 24.07, 1.9, 0.0934, 227940000, 1),
    ('Jupiter', 4332.59, 13.07, 1.3, 0.0484, 778330000, 1),
    ('Saturno', 10759.22, 9.68, 2.5, 0.0565, 1429400000, 1),
    ('Urano', 30688.5, 6.81, 0.8, 0.046381, 2870990000, 1),
    ('Neptuno', 60182, 5.43, 1.8, 0.009456, 4504300000, 1),
    ('Pluton', 90560, 4.74, 17.16, 0.2488, 5913520000, 1),
    ('Galileo', 14.65, 85, 0.004, 0.001, 2240000, 2),
    ('Brahe', 44.36, 50, 0.07, 0.007, 17200000, 2),
    ('Lipperhey', 5218, 20, 0.02, 0.005, 35900000, 2),
    ('Janssen', 0.74, 250, 0.028, 0.008, 116800000, 2),
    ('Harriot', 260, 15, 0.3, 0.03, 585500000, 2),
    ('Gliese 581 e', 3.15, 118, 0.0, 0.0, 4500000, 3),
    ('Gliese 581 b', 5.37, 101, 0.031, 0.003, 6100000, 3),
    ('Gliese 581 c', 12.9, 77, 0.07, 0.01, 10900000, 3),
    ('Kepler-11b', 10.3, 127, 0.15, 0.001, 13600000, 4),
    ('Kepler-11c', 13, 117, 0.1, 0.001, 16000000, 4),
    ('Kepler-11d', 22.7, 99, 0.14, 0.003, 23200000, 4),
    ('Kepler-11e', 32, 89, 0.13, 0.002, 29200000, 4),
    ('Kepler-11f', 46.7, 79, 0.13, 0.003, 37400000, 4),
    ('Kepler-11g', 118.4, 59, 0.15, 0.004, 69700000, 4),
    ('Epsilon Eridani b', 2779.9, 89.8, 0.15, 0.702, 493680000, 5);
    
SELECT * FROM Planeta;

-- Registrar un satelite
DELIMITER $$
CREATE PROCEDURE registrar_satelite (
    IN p_nombre VARCHAR(50),
    IN p_periodo_orbital DECIMAL (20,10),
    IN p_inclinacion_orbital DECIMAL (20,10),
    IN p_excentricidad DECIMAL (20,10),
    IN p_planeta_satelite VARCHAR(50),
    IN p_tipo_satelite ENUM('Artificial', 'Natural'),
    IN p_planeta_id INT
)
BEGIN
    -- Verificar si el planeta existe
    IF NOT EXISTS (SELECT 1 FROM Planeta WHERE id_planeta = p_planeta_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El planeta especificado no existe.';
    END IF;

    INSERT INTO Satelite (nombre, periodo_orbital, inclinacion_orbital, excentricidad, planeta_satelite, tipo_satelite, id_planeta)
    VALUES (p_nombre, p_periodo_orbital, p_inclinacion_orbital, p_excentricidad, p_planeta_satelite, p_tipo_satelite, p_planeta_id);
END $$
DELIMITER ;

-- Editar la información de un satélite natural
DELIMITER $$
CREATE PROCEDURE editar_satelite (
    IN p_id_satelite INT,
    IN p_nombre VARCHAR(50),
    IN p_periodo_orbital INT,
    IN p_inclinacion_orbital INT,
    IN p_excentricidad INT,
    IN p_planeta_satelite VARCHAR(50),
    IN p_tipo_satelite ENUM('Artificial', 'Natural')
)
BEGIN
    -- Verificar si el satélite existe
    IF NOT EXISTS (SELECT 1 FROM Satelite WHERE id_satelite = p_id_satelite) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El satélite especificado no existe.';
    END IF;

    -- Verificar si el planeta especificado existe 
    IF p_planeta_satelite IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Planeta WHERE nombre = p_planeta_satelite) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El planeta especificado no existe.';
    END IF;

    UPDATE Satelite
    SET
        nombre = p_nombre,
        periodo_orbital = p_periodo_orbital,
        inclinacion_orbital = p_inclinacion_orbital,
        excentricidad = p_excentricidad,
        planeta_satelite = p_planeta_satelite,
        tipo_satelite = p_tipo_satelite
    WHERE id_satelite = p_id_satelite;
END $$
DELIMITER ;

-- Eliminar un satélite 
DELIMITER $$
CREATE PROCEDURE eliminar_satelite (IN p_id_satelite INT)
BEGIN
    DELETE FROM Satelite
    WHERE id_satelite = p_id_satelite;
END $$
DELIMITER ;

-- Consultar los planetas con una distancia media al sol menor que la distancia dada
DELIMITER $$
CREATE PROCEDURE buscar_planetas_cercanos (IN p_distancia_maxima DECIMAL(20,10))
BEGIN
    SELECT * FROM Planeta
    WHERE distancia_sol < p_distancia_maxima;
END $$
DELIMITER ;

-- Consultar los planetas con una inclinación orbital menor a la del planeta seleccionado
DELIMITER $$
CREATE PROCEDURE consultar_planetas_por_inclinacion (IN p_id_planeta INT)
BEGIN
    DECLARE v_inclinacion_orbital DECIMAL(20,10);

    -- Obtener la inclinación orbital del planeta seleccionado
    SELECT inclinacion_orbital INTO v_inclinacion_orbital
    FROM Planeta
    WHERE id_planeta = p_id_planeta;

    -- Consultar los planetas con inclinación orbital menor a la del planeta seleccionado
    SELECT * FROM Planeta
    WHERE inclinacion_orbital < v_inclinacion_orbital;
END $$
DELIMITER ;

-- Menu
DELIMITER $$
CREATE PROCEDURE menu()
BEGIN
    DECLARE opcion INT;

    SELECT '
        ====== MENÚ PRINCIPAL =====
        1. Registrar un satélite natural
        2. Editar la información de un satélite natural
        3. Eliminar un satélite natural
        4. Consultar los planetas con una distancia media al sol menor que la distancia dada
        5. Consultar los planetas con una inclinación orbital menor a la del planeta seleccionado
        0. Salir' INTO @menu;

    -- Asignar la opción directamente para probar
    SET opcion = 1; -- Cambiar este valor para probar las otras opciones
    AppMenuLoop: LOOP
        CASE opcion
            WHEN 1 THEN -- Registrar
                SET @p_nombre = 'Hubble';
                SET @p_periodo_orbital = 4;
                SET @p_inclinacion_orbital = 17;
                SET @p_excentricidad = 14;
                SET @p_planeta_satelite = 'Marte';
                SET @p_tipo_satelite = 'Natural';
                SET @p_planeta_id = 4;
                CALL registrar_satelite(@p_nombre, @p_periodo_orbital, @p_inclinacion_orbital, @p_excentricidad, @p_planeta_satelite, @p_tipo_satelite, @p_planeta_id);

			SELECT * FROM Satelite;
                
            WHEN 2 THEN -- Editar
                SET @p_id_satelite = 1;
                SET @p_nombre = 'Luna';
                SET @p_periodo_orbital = 29;
                SET @p_inclinacion_orbital = 7;
                SET @p_excentricidad = 45;
                SET @p_planeta_satelite = 'Tierra';
                SET @p_tipo_satelite = 'Natural';
                CALL editar_satelite(@p_id_satelite, @p_nombre, @p_periodo_orbital, @p_inclinacion_orbital, @p_excentricidad, @p_planeta_satelite, @p_tipo_satelite);

			SELECT * FROM Satelite;

            WHEN 3 THEN -- Eliminar
                SET @p_id_satelite = 1;
                CALL eliminar_satelite(@p_id_satelite);
                
			SELECT * FROM Satelite;

			SELECT * FROM Satelite;

            WHEN 4 THEN -- Distancia media al sol 
                SET @p_distancia_maxima = 1770000000;
                CALL buscar_planetas_cercanos(@p_distancia_maxima);

            WHEN 5 THEN -- Inclinacion orbital menor
                SET @p_id_planeta = 5;
                CALL consultar_planetas_por_inclinacion(@p_id_planeta);

            WHEN 0 THEN
                LEAVE AppMenuLoop;

            ELSE
                SELECT 'Opción no es válida. Inténtelo de nuevo.';
        END CASE;
        SET opcion = 0;
    END LOOP AppMenuLoop;
END $$
DELIMITER ;

CALL menu;
