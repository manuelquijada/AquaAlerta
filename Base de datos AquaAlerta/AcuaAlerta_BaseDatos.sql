-- PROYECTO ACUAALERTA - EQUIPO 02
-- Semana 3: Diseño y modelado de la base de datos
-- Sistema de reportes sobre la calidad del agua.

-- 1. Crear la base de datos AcuaAlerta.

CREATE DATABASE AcuaAlerta;
GO

USE AcuaAlerta;
GO

-- 2. Registrar los usuarios del sistema.

CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(15) NULL,
    fecha_registro DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- 3. Clasificar los problemas de calidad del agua.

CREATE TABLE Categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NULL
);
GO

-- 4. Insertar las cinco categorias iniciales.

INSERT INTO Categoria (nombre, descripcion)
VALUES
('Agua turbia', 'Agua con apariencia opaca o presencia de partículas.'),
('Mal olor', 'Agua que presenta olores desagradables.'),
('Sedimentos', 'Presencia de tierra, arena u otros residuos en el agua.'),
('Posible contaminación', 'Sospecha de sustancias contaminantes en el agua.'),
('Coloración anormal', 'Agua que presenta un color diferente al habitual.');
GO

-- Verificar las categorias registradas.

SELECT * FROM Categoria;

-- 8. Registrar las ubicaciones de los reportes de agua.

CREATE TABLE Ubicacion (
    id_ubicacion INT IDENTITY(1,1) PRIMARY KEY,
    departamento VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    distrito VARCHAR(100) NULL,
    comunidad VARCHAR(150) NOT NULL,
    direccion VARCHAR(255) NULL,
    latitud DECIMAL(10,7) NULL,
    longitud DECIMAL(10,7) NULL
);
GO

-- 5. Registrar reportes y relacionarlos con usuarios y categorias.

CREATE TABLE ReporteAgua (
    id_reporte INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_categoria INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    ubicacion VARCHAR(255) NOT NULL,
    fecha_reporte DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT FK_Reporte_Usuario
        FOREIGN KEY (id_usuario)
        REFERENCES Usuario(id_usuario),

    CONSTRAINT FK_Reporte_Categoria
        FOREIGN KEY (id_categoria)
        REFERENCES Categoria(id_categoria),

    CONSTRAINT CK_Reporte_Estado
        CHECK (estado IN ('Pendiente', 'En proceso', 'Resuelto'))
);
GO

-- 6. Registrar fotografias asociadas a los reportes.

CREATE TABLE Evidencia (
    id_evidencia INT IDENTITY(1,1) PRIMARY KEY,
    id_reporte INT NOT NULL,
    nombre_archivo VARCHAR(150) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    descripcion VARCHAR(255) NULL,
    fecha_subida DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Evidencia_Reporte
        FOREIGN KEY (id_reporte)
        REFERENCES ReporteAgua(id_reporte)
);
GO

-- 7. Registrar los avances y estados de cada reporte.

CREATE TABLE Seguimiento (
    id_seguimiento INT IDENTITY(1,1) PRIMARY KEY,
    id_reporte INT NOT NULL,
    id_usuario INT NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    fecha_seguimiento DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    estado VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Seguimiento_Reporte
        FOREIGN KEY (id_reporte)
        REFERENCES ReporteAgua(id_reporte),

    CONSTRAINT FK_Seguimiento_Usuario
        FOREIGN KEY (id_usuario)
        REFERENCES Usuario(id_usuario),

    CONSTRAINT CK_Seguimiento_Estado
        CHECK (estado IN ('Pendiente', 'En proceso', 'Resuelto'))
);
GO