
SET datestyle = 'ISO, DMY';

CREATE TABLE  IF NOT EXISTS Rol (
    id_rol INTEGER PRIMARY KEY,
    Rol VARCHAR(20) NOT NULL
);

INSERT INTO Rol (id_rol, Rol) VALUES
(1, 'Miembro'),
(2, 'Ministro Potencial'),
(3, 'Ministro'),
(4, 'Ministro Apoyo'),
(5, 'Equipador'),
(6, 'Equipadora'),
(7, 'Plantador'),
(8, 'Plantadora'),
(9, 'Evangelista'),
(10, 'Pastor'),
(11, 'Pastora'),
(12, 'Pastor Principal'),
(13, 'Pastora Principal'),
(14, 'Apostol'),
(15, 'Profeta');


CREATE TABLE IF NOT EXISTS RedTipo (
    id_redtipo INTEGER PRIMARY KEY,
    RedTipo VARCHAR(20) NOT NULL
);

INSERT INTO RedTipo (id_redtipo, RedTipo) VALUES
(1, 'Hombres'),
(2, 'Mujeres'),
(3, 'Evangelistas'),
(4, 'PreJuveniles'),
(5, 'Jovenes'),
(6, 'Niños'),
(7, 'Junior'),
(8, 'Mejor Edad');

CREATE TABLE IF NOT EXISTS Estado (
    id_estado INTEGER PRIMARY KEY,
    Estado VARCHAR(20) NOT NULL
);

INSERT INTO Estado (id_estado, Estado) VALUES
(1, 'Activo'),
(2, 'Baja'),
(3, 'Vacaciones'),
(4, 'Suspendido'),
(5, 'Especial');

CREATE TABLE IF NOT EXISTS Redde (
    id_redde INTEGER PRIMARY KEY,
    Redde VARCHAR(10) NOT NULL,
    id_lider INTEGER NOT NULL
);

INSERT INTO Redde (id_redde, Redde, id_lider) VALUES
(1, 'Hombres', 1),
(2, 'Mujeres', 2);




-- Crear tabla 'usuarios'
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INTEGER PRIMARY KEY,
    FechaAlta DATE,
    Nombre VARCHAR(100),
    id_lider INTEGER
);

-- Cargar datos en 'usuarios' desde CSV
COPY usuarios(id_usuario, FechaAlta, Nombre, id_lider)
FROM '/docker-entrypoint-initdb.d/usuarios.csv'
DELIMITER ';'
CSV HEADER;

-- Crear tabla 'Datos_Personales_usr'
CREATE TABLE IF NOT EXISTS Datos_Personales_usr (
    id_usuario INTEGER PRIMARY KEY,
    FechaAlta DATE,
    Telefono VARCHAR(20),
    email VARCHAR(100),
    fechanacimiento DATE,
    Dia INTEGER,
    Mes INTEGER,
    Nacionalidad VARCHAR(50)
);

-- Cargar datos en 'Datos_Personales_usr' desde CSV
COPY Datos_Personales_usr(id_usuario, FechaAlta, Telefono, email, fechanacimiento, Dia, Mes, Nacionalidad)
FROM '/docker-entrypoint-initdb.d/Datos_Personales_usr.csv'
DELIMITER ';'
CSV HEADER;


-- Crear tabla Redes
CREATE TABLE IF NOT EXISTS Redes (
    id_red INTEGER PRIMARY KEY,
    FechaAlta DATE,
    id_lider INTEGER,
    id_redtipo VARCHAR(50)
);

-- Cargar datos en 'Redes' desde CSV
COPY Redes (id_red, FechaAlta ,id_lider ,id_redtipo)
FROM '/docker-entrypoint-initdb.d/redes.csv'
DELIMITER ';'
CSV HEADER;




-- Crear tabla Lideres
CREATE TABLE IF NOT EXISTS Lideres (
    id_lider INTEGER PRIMARY KEY,
    FechaAlta DATE,
	Nombre VARCHAR(100)
);

-- Cargar datos en 'Lideres' desde CSV
COPY Lideres(id_lider, FechaAlta ,Nombre)
FROM '/docker-entrypoint-initdb.d/Lideres.csv'
DELIMITER ';'
CSV HEADER;



-- Crear tabla D_Lider_HIST
CREATE TABLE IF NOT EXISTS D_Lider_HIST (
    id_lider INTEGER NOT NULL,
	FechaDatos DATE NOT NULL,
	id_Estado INTEGER,
	id_rol INTEGER,
	id_Red INTEGER,
	id_Tipored INTEGER,
	id_Sulider INTEGER,
	id_liderSu INTEGER,
	id_LiderPral INTEGER
);

-- Cargar datos en 'D_Lider_HIST' desde CSV
COPY D_Lider_HIST(id_Lider ,FechaDatos ,id_Estado ,id_rol , id_Red , id_Tipored , id_Sulider , id_liderSu , id_LiderPral)
FROM '/docker-entrypoint-initdb.d/D_Lider_HIST.csv'
DELIMITER ';'
CSV HEADER;

-- Crear tabla Codigos_Postales
CREATE TABLE IF NOT EXISTS Codigos_Postales (
    cp VARCHAR(5) NOT NULL,
	poblacion VARCHAR(50) NOT NULL,
	municipio VARCHAR(50) NOT NULL,
	provincia VARCHAR(50) NOT NULL,
	comunidad VARCHAR(50) NOT NULL
);

-- Cargar datos en 'Codigos_Postales' desde CSV
COPY Codigos_Postales(cp, poblacion ,municipio ,provincia ,comunidad)
FROM '/docker-entrypoint-initdb.d/codigos_postales.csv'
DELIMITER ';'
CSV HEADER;