-- ============================================================
-- TalentCore HR - People Analytics
-- SQL Queries for Business Intelligence
-- ============================================================
-- Database: MySQL 8.0+
-- Author: Ivan
-- Purpose: HR metrics and workforce insights
-- ============================================================

USE talentcore_hr;

-- ============================================================
-- QUERY 1: Headcount & Payroll by Department
-- ============================================================
-- Business Question: How is our workforce distributed across
-- departments, and where is our compensation budget allocated?
--
-- Key Metrics:
--   - Active employee count per department
--   - Total payroll (mass salarial)
--   - Average salary per department
--
-- Use Case: Budget planning, workforce distribution analysis
-- ============================================================

SELECT
    dep.nombre AS nombre_departamento,
    COUNT(emp.id_empleado) AS total_empleados,
    SUM(sal.salario) AS masa_salarial_total,
    AVG(sal.salario) AS salario_promedio_departamento
FROM departamentos dep
INNER JOIN empleados emp
    ON dep.id_departamento = emp.id_departamento
INNER JOIN salarios sal
    ON emp.id_empleado = sal.id_empleado
WHERE emp.activo = TRUE
  AND sal.fecha_fin IS NULL  -- Current salaries only
GROUP BY dep.nombre
ORDER BY masa_salarial_total DESC;


-- ============================================================
-- QUERY 2: Employee Turnover by Year
-- ============================================================
-- Business Question: What are our hiring and attrition trends,
-- and is the company growing or contracting?
--
-- Key Metrics:
--   - Annual hires
--   - Annual departures
--   - Net change (hires - departures)
--
-- Use Case: Retention strategy, workforce planning
-- Technical Notes: Uses CTEs to separate hire and departure
-- calculations, LEFT JOIN ensures years with no departures
-- still appear in results
-- ============================================================

WITH tabla_contrataciones AS (
    SELECT
        YEAR(fecha_ingreso) AS año,
        COUNT(*) AS hires
    FROM empleados
    GROUP BY YEAR(fecha_ingreso)
),
tabla_bajas AS (
    SELECT
        YEAR(fecha_salida) AS año,
        COUNT(*) AS departures
    FROM empleados
    WHERE fecha_salida IS NOT NULL
    GROUP BY YEAR(fecha_salida)
)
SELECT
    tc.año,
    tc.hires AS total_contrataciones,
    COALESCE(tb.departures, 0) AS total_bajas,
    tc.hires - COALESCE(tb.departures, 0) AS diferencia_neta
FROM tabla_contrataciones tc
LEFT JOIN tabla_bajas tb
    ON tc.año = tb.año
ORDER BY tc.año ASC;


-- ============================================================
-- QUERY 3: Salary Analysis by Department & Level
-- ============================================================
-- Business Question: Are we paying competitively across
-- different departments and seniority levels?
--
-- Key Metrics:
--   - Employee count by department-level combination
--   - Salary min/avg/max for each group
--   - Salary distribution patterns
--
-- Use Case: Compensation benchmarking, salary equity analysis
-- Technical Notes: Multi-level GROUP BY enables detailed
-- salary comparison across two dimensions
-- ============================================================

SELECT
    dep.nombre AS nombre_departamento,
    car.nivel AS nivel_cargo,
    COUNT(emp.id_empleado) AS total_empleados,
    MIN(sal.salario) AS salario_minimo,
    AVG(sal.salario) AS salario_promedio,
    MAX(sal.salario) AS salario_maximo
FROM departamentos dep
INNER JOIN empleados emp
    ON dep.id_departamento = emp.id_departamento
INNER JOIN cargos car
    ON emp.id_cargo = car.id_cargo
INNER JOIN salarios sal
    ON emp.id_empleado = sal.id_empleado
WHERE emp.activo = TRUE
  AND sal.fecha_fin IS NULL
GROUP BY dep.nombre, car.nivel
ORDER BY dep.nombre ASC, car.nivel ASC;


-- ============================================================
-- QUERY 4: Absenteeism Rate by Department
-- ============================================================
-- Business Question: Which departments have the highest
-- absence rates, and what types of absences are most common?
--
-- Key Metrics:
--   - Total absence days per department
--   - Average absence days per employee
--   - Most frequent absence type by department
--
-- Use Case: Operational planning, absence policy optimization
-- Technical Notes: Uses ROW_NUMBER() window function to rank
-- absence types by frequency within each department, then
-- filters for rank = 1 to get the most common type
-- ============================================================

WITH tabla_ausencias AS (
    -- Aggregate total absence days per employee for 2024
    SELECT
        id_empleado,
        SUM(dias) AS dias_ausencias
    FROM ausencias
    WHERE YEAR(fecha_inicio) = 2024
    GROUP BY id_empleado
),
tabla_tipos_frec AS (
    -- Rank absence types by frequency within each department
    SELECT
        e.id_departamento,
        a.tipo,
        COUNT(*) AS frecuencia,
        ROW_NUMBER() OVER(
            PARTITION BY e.id_departamento 
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM ausencias a
    INNER JOIN empleados e
        ON a.id_empleado = e.id_empleado
    WHERE YEAR(a.fecha_inicio) = 2024
    GROUP BY e.id_departamento, a.tipo
)
SELECT
    dep.nombre AS nombre_departamento,
    COUNT(emp.id_empleado) AS empleados_activos,
    SUM(tau.dias_ausencias) AS total_dias_ausencia,
    AVG(tau.dias_ausencias) AS prom_dias_ausencia,
    ttf.tipo AS tipo_aus_frecuente
FROM departamentos dep
INNER JOIN empleados emp
    ON dep.id_departamento = emp.id_departamento
-- Subquery filters for most frequent absence type (rn = 1)
INNER JOIN (
    SELECT id_departamento, tipo
    FROM tabla_tipos_frec
    WHERE rn = 1
) ttf
    ON dep.id_departamento = ttf.id_departamento
INNER JOIN tabla_ausencias tau
    ON emp.id_empleado = tau.id_empleado
WHERE emp.activo = TRUE
GROUP BY dep.nombre, ttf.tipo
ORDER BY total_dias_ausencia DESC;


-- ============================================================
-- QUERY 5: Performance vs Salary Range
-- ============================================================
-- Business Question: Are our top performers compensated
-- appropriately within their salary bands?
--
-- Key Metrics:
--   - Q4 2024 performance evaluation scores
--   - Current salary vs. job salary band
--   - Classification: Below Band / Within Band / Above Band
--
-- Use Case: Merit increase planning, pay-for-performance
-- alignment, promotion readiness assessment
-- Technical Notes: CASE WHEN logic classifies salary position
-- relative to job salary bands, CONCAT displays band ranges
-- ============================================================

SELECT
    emp.nombre AS nombre_completo,
    dep.nombre AS departamento,
    car.nivel AS nivel_cargo,
    eva.puntaje AS puntaje_evaluacion_2024,
    sal.salario AS salario_actual,
    CONCAT(car.banda_min, '-', car.banda_max) AS banda_salarial,
    CASE
        WHEN sal.salario < car.banda_min THEN 'Below Band'
        WHEN sal.salario BETWEEN car.banda_min AND car.banda_max THEN 'Within Band'
        WHEN sal.salario > car.banda_max THEN 'Above Band'
    END AS posicion_salarial
FROM empleados emp
INNER JOIN departamentos dep
    ON emp.id_departamento = dep.id_departamento
INNER JOIN cargos car
    ON emp.id_cargo = car.id_cargo
INNER JOIN evaluaciones eva
    ON emp.id_empleado = eva.id_empleado
LEFT JOIN salarios sal
    ON emp.id_empleado = sal.id_empleado
WHERE emp.activo = TRUE
  AND eva.periodo = '2024-Q4'
  AND sal.fecha_fin IS NULL
ORDER BY eva.puntaje DESC;


-- ============================================================
-- End of Queries
-- ============================================================
