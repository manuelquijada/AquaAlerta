/*
 ACUAALERTA - EQUIPO 02
 SCRIPT MAESTRO FINAL - DISEÑO DE BASES DE DATOS
 Fuente: estructura y datos recuperados de SQL Server el 10/11/2026.
 Contiene únicamente las seis tablas dbo del proyecto de base de datos.
 NO incluye ni modifica las tablas Django (auth_, django_, reportes_, usuarios_).
 EJECUTAR SOLO EN UN ENTORNO DE PRUEBAS NUEVO: crea la base AcuaAlerta
 y fallará si la base ya existe. No ejecutar en la base actual.
 Los datos incluidos son de prueba; el hash de contraseña es SIMULADO.
*/

-- 01. CREACIÓN DE LA BASE DE DATOS (SOLO INSTALACIÓN NUEVA)
IF DB_ID(N'AcuaAlerta') IS NOT NULL
    THROW 50001, 'La base AcuaAlerta ya existe. No ejecute este script sobre su base actual.', 1;
GO
CREATE DATABASE [AcuaAlerta];
GO
USE [AcuaAlerta];
GO

-- 02. DEFINICIÓN DE TABLAS
CREATE TABLE dbo.Usuario (
    id_usuario int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    correo varchar(150) NOT NULL UNIQUE,
    contrasena_hash varchar(255) NOT NULL,
    telefono varchar(15) NULL,
    fecha_registro datetime2(7) NOT NULL DEFAULT (SYSDATETIME()),
    rol varchar(30) NOT NULL CONSTRAINT DF_Usuario_Rol DEFAULT ('Habitante'),
    CONSTRAINT CK_Usuario_Rol CHECK (rol IN ('Administrador', 'Representante comunitario', 'Habitante'))
);
GO

CREATE TABLE dbo.Categoria (
    id_categoria int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre varchar(100) NOT NULL UNIQUE,
    descripcion varchar(255) NULL
);
GO

CREATE TABLE dbo.Ubicacion (
    id_ubicacion int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    departamento varchar(100) NOT NULL,
    municipio varchar(100) NOT NULL,
    distrito varchar(100) NULL,
    comunidad varchar(150) NOT NULL,
    direccion varchar(255) NULL,
    latitud decimal(10,7) NULL,
    longitud decimal(10,7) NULL
);
GO

CREATE TABLE dbo.ReporteAgua (
    id_reporte int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_usuario int NOT NULL,
    id_categoria int NOT NULL,
    titulo varchar(150) NOT NULL,
    descripcion varchar(500) NOT NULL,
    ubicacion varchar(255) NOT NULL,
    fecha_reporte datetime2(7) NOT NULL DEFAULT (SYSDATETIME()),
    estado varchar(20) NOT NULL DEFAULT ('Pendiente'),
    id_ubicacion int NULL,
    prioridad varchar(10) NOT NULL CONSTRAINT DF_ReporteAgua_Prioridad DEFAULT ('Media'),
    CONSTRAINT CK_Reporte_Estado CHECK (estado IN ('Atendido', 'En revisión', 'Pendiente')),
    CONSTRAINT CK_ReporteAgua_Prioridad CHECK (prioridad IN ('Baja', 'Media', 'Alta')),
    CONSTRAINT FK_Reporte_Usuario FOREIGN KEY (id_usuario) REFERENCES dbo.Usuario(id_usuario),
    CONSTRAINT FK_Reporte_Categoria FOREIGN KEY (id_categoria) REFERENCES dbo.Categoria(id_categoria),
    CONSTRAINT FK_Reporte_Ubicacion FOREIGN KEY (id_ubicacion) REFERENCES dbo.Ubicacion(id_ubicacion)
);
GO

CREATE TABLE dbo.Evidencia (
    id_evidencia int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_reporte int NOT NULL,
    nombre_archivo varchar(150) NOT NULL,
    ruta_archivo varchar(500) NOT NULL,
    descripcion varchar(255) NULL,
    fecha_subida datetime2(7) NOT NULL DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_Evidencia_Reporte FOREIGN KEY (id_reporte) REFERENCES dbo.ReporteAgua(id_reporte)
);
GO

CREATE TABLE dbo.Seguimiento (
    id_seguimiento int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_reporte int NOT NULL,
    id_usuario int NOT NULL,
    descripcion varchar(500) NOT NULL,
    fecha_seguimiento datetime2(7) NOT NULL DEFAULT (SYSDATETIME()),
    estado varchar(20) NOT NULL,
    CONSTRAINT CK_Seguimiento_Estado CHECK (estado IN ('Atendido', 'En revisión', 'Pendiente')),
    CONSTRAINT FK_Seguimiento_Reporte FOREIGN KEY (id_reporte) REFERENCES dbo.ReporteAgua(id_reporte),
    CONSTRAINT FK_Seguimiento_Usuario FOREIGN KEY (id_usuario) REFERENCES dbo.Usuario(id_usuario)
);
GO

-- 03. DATOS RECUPERADOS (13 REGISTROS)
-- Identificadores y fechas conservados tal como se extrajeron de SQL Server.
SET IDENTITY_INSERT dbo.Usuario ON;
INSERT dbo.Usuario (id_usuario,nombre,apellido,correo,contrasena_hash,telefono,fecha_registro,rol)
VALUES (2,N'Usuario',N'Prueba',N'prueba.aquaalerta@example.com',N'HASH_SIMULADO_NO_REAL',N'70000000',CAST(N'2026-11-10T17:34:08.2437949' AS datetime2),N'Administrador');
SET IDENTITY_INSERT dbo.Usuario OFF;
GO

SET IDENTITY_INSERT dbo.Categoria ON;
INSERT dbo.Categoria (id_categoria,nombre,descripcion) VALUES
(1,N'Agua turbia',N'Agua con apariencia opaca o presencia de partículas.'),
(2,N'Mal olor',N'Agua que presenta olores desagradables.'),
(3,N'Sedimentos',N'Presencia de tierra, arena u otros residuos en el agua.'),
(4,N'Posible contaminación',N'Sospecha de sustancias contaminantes en el agua.'),
(5,N'Coloración anormal',N'Agua que presenta un color diferente al habitual.'),
(6,N'Falta de agua',N'Interrupción del suministro de agua'),
(7,N'Baja presión',N'Presión insuficiente en el servicio'),
(8,N'Fugas de agua',N'Pérdidas de agua en tuberías'),
(9,N'Tuberías dañadas',N'Daños en la red de distribución');
SET IDENTITY_INSERT dbo.Categoria OFF;
GO

SET IDENTITY_INSERT dbo.Ubicacion ON;
INSERT dbo.Ubicacion (id_ubicacion,departamento,municipio,distrito,comunidad,direccion,latitud,longitud)
VALUES (1,N'Chalatenango',N'Chalatenango',N'Santa Rita',N'El Cobano',N'Sector centro',NULL,NULL);
SET IDENTITY_INSERT dbo.Ubicacion OFF;
GO

SET IDENTITY_INSERT dbo.ReporteAgua ON;
INSERT dbo.ReporteAgua (id_reporte,id_usuario,id_categoria,titulo,descripcion,ubicacion,fecha_reporte,estado,id_ubicacion,prioridad)
VALUES (1,2,3,N'Presencia de sedimentos en el agua',N'Se observa una capa de sedimentos en el agua suministrada a la comunidad.',N'El Cobano, sector centro',CAST(N'2026-11-10T17:41:14.2242728' AS datetime2),N'Pendiente',1,N'Alta');
SET IDENTITY_INSERT dbo.ReporteAgua OFF;
GO

SET IDENTITY_INSERT dbo.Seguimiento ON;
INSERT dbo.Seguimiento (id_seguimiento,id_reporte,id_usuario,descripcion,fecha_seguimiento,estado)
VALUES (2,1,2,N'Se recibió el reporte y se realizó una revisión inicial de la calidad del agua.',CAST(N'2026-11-10T17:47:58.9166021' AS datetime2),N'Atendido');
SET IDENTITY_INSERT dbo.Seguimiento OFF;
GO
-- dbo.Evidencia no tenía registros en la extracción.

-- 04. VERIFICACIONES DE ESTRUCTURA Y REGISTROS
SELECT 'Usuario' AS Tabla,COUNT(*) AS Registros FROM dbo.Usuario
UNION ALL SELECT 'Categoria',COUNT(*) FROM dbo.Categoria
UNION ALL SELECT 'Ubicacion',COUNT(*) FROM dbo.Ubicacion
UNION ALL SELECT 'ReporteAgua',COUNT(*) FROM dbo.ReporteAgua
UNION ALL SELECT 'Evidencia',COUNT(*) FROM dbo.Evidencia
UNION ALL SELECT 'Seguimiento',COUNT(*) FROM dbo.Seguimiento;
GO

SELECT fk.name AS Nombre_Relacion,OBJECT_NAME(fk.parent_object_id) AS Tabla_Origen,
       COL_NAME(fkc.parent_object_id,fkc.parent_column_id) AS Clave_Foranea,
       OBJECT_NAME(fk.referenced_object_id) AS Tabla_Destino,
       COL_NAME(fkc.referenced_object_id,fkc.referenced_column_id) AS Clave_Primaria
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id=fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) IN ('ReporteAgua','Evidencia','Seguimiento')
ORDER BY Tabla_Origen;
GO

SELECT TABLE_NAME AS Tabla,COLUMN_NAME AS Columna,DATA_TYPE AS Tipo_Dato,
       CHARACTER_MAXIMUM_LENGTH AS Longitud,IS_NULLABLE AS Permite_Nulos
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Usuario','Categoria','Ubicacion','ReporteAgua','Evidencia','Seguimiento')
ORDER BY TABLE_NAME,ORDINAL_POSITION;
GO

SELECT OBJECT_NAME(parent_object_id) AS Tabla,name AS Restriccion,definition AS Condicion
FROM sys.check_constraints
WHERE OBJECT_NAME(parent_object_id) IN ('Usuario','ReporteAgua','Seguimiento')
ORDER BY Tabla,Restriccion;
GO

SELECT id_categoria,nombre,descripcion FROM dbo.Categoria ORDER BY id_categoria;
GO

-- 05. CONSULTAS RELACIONALES Y DE ANÁLISIS
SELECT r.id_reporte,r.titulo AS Reporte,u.nombre+' '+u.apellido AS Usuario,
       c.nombre AS Categoria,ub.comunidad AS Comunidad,ub.departamento AS Departamento,
       r.estado AS Estado,r.prioridad AS Prioridad
FROM dbo.ReporteAgua r
INNER JOIN dbo.Usuario u ON r.id_usuario=u.id_usuario
INNER JOIN dbo.Categoria c ON r.id_categoria=c.id_categoria
INNER JOIN dbo.Ubicacion ub ON r.id_ubicacion=ub.id_ubicacion;
GO

SELECT c.nombre AS Categoria,COUNT(r.id_reporte) AS Total_Reportes
FROM dbo.Categoria c
LEFT JOIN dbo.ReporteAgua r ON c.id_categoria=r.id_categoria
GROUP BY c.nombre
ORDER BY Total_Reportes DESC,c.nombre;
GO

SELECT r.id_reporte,r.titulo AS Reporte,r.estado AS Estado_Reporte,
       s.descripcion AS Seguimiento,s.estado AS Estado_Seguimiento,
       s.fecha_seguimiento AS Fecha,u.nombre+' '+u.apellido AS Responsable
FROM dbo.ReporteAgua r
INNER JOIN dbo.Seguimiento s ON r.id_reporte=s.id_reporte
INNER JOIN dbo.Usuario u ON s.id_usuario=u.id_usuario
ORDER BY s.fecha_seguimiento DESC;
GO

-- 06. PRUEBA CONTROLADA DE INTEGRIDAD REFERENCIAL
-- Se intenta insertar un reporte con un usuario inexistente.
-- La transacción se revierte tanto si hay error como si se acepta.
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.ReporteAgua (id_usuario,id_categoria,id_ubicacion,titulo,descripcion,ubicacion,estado,prioridad)
    VALUES (-999,3,1,N'Prueba de integridad referencial',N'Intento de registrar un reporte con usuario inexistente.',N'El Cobano',N'Pendiente',N'Media');
    ROLLBACK TRANSACTION;
    SELECT N'ADVERTENCIA: inserción aceptada inesperadamente (revertida)' AS Resultado;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT ERROR_NUMBER() AS Codigo_Error,ERROR_MESSAGE() AS Resultado;
END CATCH;
GO

/* NOTAS:
 - El script reproduce la estructura y datos recuperados, pero no constituye un respaldo .bak.
 - Los INSERT se basan en datos de prueba y no incluyen registros de dbo.Evidencia.
 - Los datos originales no fueron modificados para generar este archivo.
 - Se conserva el campo ubicacion junto con id_ubicacion tal como existe en SQL Server.
 - Las restricciones y fechas corresponden a la estructura extraída, no al script inicial de Semana 3.
 - Para verificar la instalación, ejecutar únicamente en una instancia/base nueva de pruebas.
*/
