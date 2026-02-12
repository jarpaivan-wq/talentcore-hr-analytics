-- ============================================================
-- TalentCore HR - People Analytics Database
-- Schema: Tables Creation
-- ============================================================

CREATE DATABASE IF NOT EXISTS talentcore_hr;
USE talentcore_hr;

-- ------------------------------------------------------------
-- Table 1: departamentos
-- ------------------------------------------------------------
CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre          VARCHAR(50)  NOT NULL,
    ubicacion       VARCHAR(50),
    activo          BOOLEAN      DEFAULT TRUE
);

-- ------------------------------------------------------------
-- Table 2: cargos
-- ------------------------------------------------------------
CREATE TABLE cargos (
    id_cargo    INT PRIMARY KEY AUTO_INCREMENT,
    titulo      VARCHAR(50)  NOT NULL,
    nivel       VARCHAR(20)  NOT NULL,  -- Junior / Mid / Senior / Lead / Manager
    banda_min   DECIMAL(10,2) NOT NULL,
    banda_max   DECIMAL(10,2) NOT NULL
);

-- ------------------------------------------------------------
-- Table 3: empleados
-- ------------------------------------------------------------
CREATE TABLE empleados (
    id_empleado       INT PRIMARY KEY AUTO_INCREMENT,
    nombre            VARCHAR(50)  NOT NULL,
    apellido          VARCHAR(50)  NOT NULL,
    email             VARCHAR(100) UNIQUE NOT NULL,
    id_departamento   INT          NOT NULL,
    id_cargo          INT          NOT NULL,
    fecha_ingreso     DATE         NOT NULL,
    fecha_salida      DATE         DEFAULT NULL,  -- NULL = still active
    activo            BOOLEAN      DEFAULT TRUE,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    FOREIGN KEY (id_cargo)        REFERENCES cargos(id_cargo)
);

-- ------------------------------------------------------------
-- Table 4: salarios
-- ------------------------------------------------------------
CREATE TABLE salarios (
    id_salario    INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado   INT           NOT NULL,
    salario       DECIMAL(10,2) NOT NULL,
    fecha_inicio  DATE          NOT NULL,
    fecha_fin     DATE          DEFAULT NULL,  -- NULL = current salary
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- ------------------------------------------------------------
-- Table 5: ausencias
-- ------------------------------------------------------------
CREATE TABLE ausencias (
    id_ausencia   INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado   INT         NOT NULL,
    tipo          VARCHAR(30) NOT NULL,  -- sick_leave / vacation / personal / unpaid
    fecha_inicio  DATE        NOT NULL,
    fecha_fin     DATE        NOT NULL,
    dias          INT         NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- ------------------------------------------------------------
-- Table 6: evaluaciones
-- ------------------------------------------------------------
CREATE TABLE evaluaciones (
    id_evaluacion  INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado    INT          NOT NULL,
    periodo        VARCHAR(10)  NOT NULL,  -- e.g. '2024-Q1'
    puntaje        DECIMAL(3,1) NOT NULL,  -- 1.0 to 5.0
    comentarios    TEXT,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);
