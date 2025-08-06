
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
    fechadatos DATE,
    telefono VARCHAR(20),
    email VARCHAR(100),
    fechanacimiento DATE,
    Dia INTEGER,
    Mes INTEGER,
    nacionalidad VARCHAR(50)
);

-- Cargar datos en 'Datos_Personales_usr' desde CSV
COPY Datos_Personales_usr(id_usuario, fechadatos, telefono, email, fechanacimiento, Dia, Mes, nacionalidad)
FROM '/docker-entrypoint-initdb.d/Datos_Personales_usr.csv'
DELIMITER ';'
CSV HEADER;


-- Crear tabla Redes
CREATE TABLE IF NOT EXISTS Redes (
    id_red INTEGER PRIMARY KEY,
    FechaAlta DATE,
    id_lider INTEGER,
    id_redtipo INTEGER
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
	id_RedTipo INTEGER,
	id_Sulider INTEGER,
	id_liderSu INTEGER,
	id_LiderPral INTEGER
);

-- Cargar datos en 'D_Lider_HIST' desde CSV
COPY D_Lider_HIST(id_Lider ,FechaDatos ,id_Estado ,id_rol , id_Red , id_RedTipo , id_Sulider , id_liderSu , id_LiderPral)
FROM '/docker-entrypoint-initdb.d/D_Lider_HIST.csv'
DELIMITER ';'
CSV HEADER;


-- Crea vista de datos usuarios cumpleaños y datos de lideres
-- Esta vista muestra los usuarios con sus cumpleaños y los datos del líder asociado.
-- filtrado por estado activo y excluyendo aquellos con estado 'Baja' '2'

CREATE OR REPLACE VIEW vista_usuarios_cumpleanos_lider AS
SELECT 
    u.Nombre AS NombreUsuario,
    l.nombre AS NombreLider,
    l.id_lider,
    d.telefono ,
    d.dia,
    d.mes,
    dlh.fechadatos,
    dlh.id_Estado,
    dlh.id_rol,
    dlh.id_Red,
    dlh.id_RedTipo,
    dlh.id_Sulider,
    dlh.id_liderSu,
    dlh.id_LiderPral
FROM usuarios u
JOIN datos_personales_usr d ON u.id_usuario = d.id_usuario
JOIN lideres l ON l.id_lider = u.id_lider
JOIN (
    SELECT DISTINCT ON (id_lider) *
    FROM d_lider_hist
    ORDER BY id_lider, fechadatos DESC
) dlh ON dlh.id_lider = u.id_lider
WHERE dlh.id_Estado <> 2
ORDER BY u.id_lider;


-- crear vista de datos lideres actuales solo fintrado por estado activoactivo
-- Esta vista muestra los datos actuales de los líderes, excluyendo aquellos con estado 'Baja' '2'
-- y ordenados por fecha de datos más reciente.

CREATE OR REPLACE VIEW vista_lideres_datos_actuales AS
SELECT DISTINCT ON (dlh.id_lider)
    dlh.id_lider,
    l.nombre as NombreLider,
    dlh.fechadatos,
    
    -- Estado
    dlh.id_estado,
    e.estado,
    
    -- Rol
    dlh.id_rol,
    r.rol,
    
    -- Red
    dlh.id_red,
    re.id_redtipo,
    rt.redtipo,
    re.id_lider AS id_lider_red,
    lr.nombre AS nombre_lider_red,
    
    -- SuLíder
    dlh.id_sulider,
    ls.nombre AS nombre_sulider,
    
    -- LíderSu
    dlh.id_lidersu,
    lsu.nombre AS nombre_lidersu,
    
    -- Líder Principal
    dlh.id_liderpral,
    lp.nombre AS nombre_lider_principal

FROM d_lider_hist dlh
JOIN estado e ON dlh.id_estado = e.id_estado
JOIN rol r ON dlh.id_rol = r.id_rol
JOIN redes re ON dlh.id_red = re.id_red
JOIN redtipo rt ON re.id_redtipo::INTEGER = rt.id_redtipo  -- CAST si es necesario
JOIN lideres l ON dlh.id_lider = l.id_lider
JOIN lideres lr ON re.id_lider = lr.id_lider
JOIN lideres ls ON dlh.id_sulider = ls.id_lider
JOIN lideres lsu ON dlh.id_lidersu = lsu.id_lider
JOIN lideres lp ON dlh.id_liderpral = lp.id_lider

WHERE dlh.id_estado <> 2
ORDER BY dlh.id_lider, dlh.fechadatos DESC;

-- crear vista cumpleanos utilizando las vistas
CREATE OR REPLACE VIEW vista_cumpleanos AS
select u.nombreusuario,u.dia, u.mes, u.telefono 
,v.*
from vista_lideres_datos_actuales v
join vista_usuarios_cumpleanos_lider u on v.id_lider = u.id_lider;

-- crea vista cumpleanos mes actual
CREATE OR REPLACE VIEW vista_cumpleanos_mes_actual AS
SELECT *
FROM vista_cumpleanos
WHERE mes = EXTRACT(MONTH FROM CURRENT_DATE)  order by dia asc;

-- Function: fn_listado_cumplenos_segun_mes
-- Description: Devuelve el listado de usuarios que cumplen años en el mes especificado

CREATE OR REPLACE FUNCTION fn_listado_cumpleanos_segun_mes(mes_param INTEGER)
RETURNS TABLE (
    nombreusuario VARCHAR(100),
    dia INTEGER,
    mes INTEGER,
    telefono VARCHAR(20),
    id_lider INTEGER,
    fechadatos DATE,
    estado VARCHAR(50),
    rol VARCHAR(50),
    redtipo VARCHAR(50),
    nombre_lider_red VARCHAR(100),
    nombre_sulider VARCHAR(100),
    nombre_lidersu VARCHAR(100),
    nombre_lider_principal VARCHAR(100)
) AS $$
BEGIN
    IF mes_param < 1 OR mes_param > 12 THEN
        RAISE EXCEPTION 'Mes inválido: %', mes_param;
    END IF;

    RETURN QUERY
    SELECT 
        v.nombreusuario,
        v.dia,
        v.mes,
        v.telefono,
        v.id_lider,
        v.fechadatos,
        v.estado,
        v.rol,
        v.redtipo,
        v.nombre_lider_red,
        v.nombre_sulider,
        v.nombre_lidersu,
        v.nombre_lider_principal
    FROM vista_cumpleanos v
    WHERE v.mes = mes_param
    ORDER BY v.dia ASC;
END;
$$ LANGUAGE plpgsql;

-- crea la funcion para buscar por nombre de lider

CREATE OR REPLACE FUNCTION fn_buscar_lider_por_nombre(busqueda TEXT)
RETURNS SETOF vista_lideres_datos_actuales AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.vista_lideres_datos_actuales
    WHERE nombrelider ILIKE '%' || busqueda || '%';
END;
$$ LANGUAGE plpgsql;

/*
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
*/