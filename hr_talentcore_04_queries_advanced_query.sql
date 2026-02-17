-- =====================================================
-- Query: Top 3 Employees by Salary per Department
-- =====================================================
-- Author: Iván Jarpa
-- Database: MySQL 8.0+
-- Source: talentcore_hr (HR Analytics portfolio project)
-- LinkedIn Post: [Add your post link after publishing]
-- =====================================================
--
-- BUSINESS CONTEXT:
-- HR department needs to identify top performers by compensation
-- in departments that meet minimum standards (size and pay level).
-- This analysis supports compensation reviews, retention planning,
-- and department benchmarking.
--
-- BUSINESS RULES:
-- 1. Only include departments with average salary > $60,000
-- 2. Only include departments with more than 3 active employees
-- 3. Rank employees by current salary within their department
-- 4. Show top 3 employees per eligible department
-- 5. Handle salary ties properly (DENSE_RANK)
--
-- TECHNICAL APPROACH:
-- Using 4 CTEs to decompose the problem:
--   CTE 1: Calculate average salary per department
--   CTE 2: Count active employees per department
--   CTE 3: Rank employees by salary using DENSE_RANK()
--   CTE 4: Combine all data and apply business filters
--
-- WHY DENSE_RANK vs RANK vs ROW_NUMBER?
-- - DENSE_RANK: Handles ties without gaps (1,2,2,3) ✓ CHOSEN
-- - RANK: Creates gaps after ties (1,2,2,4)
-- - ROW_NUMBER: Arbitrary ordering of ties (1,2,3)
--
-- Since we want to include ALL employees tied at rank 3,
-- DENSE_RANK is the correct choice.
-- =====================================================

USE talentcore_hr;

-- =====================================================
-- CTE 1: Average Salary per Department
-- =====================================================
-- Purpose: Calculate average current salary for each department
-- Filters: Only active employees with current salary (fecha_fin IS NULL)
-- =====================================================
WITH tab_sal_prom_dept AS (
    SELECT
        dep.id_departamento,
        AVG(sal.salario) AS prom_salario_dept
    FROM empleados emp
    INNER JOIN departamentos dep
        ON emp.id_departamento = dep.id_departamento
    INNER JOIN salarios sal
        ON emp.id_empleado = sal.id_empleado
    WHERE sal.fecha_fin IS NULL      -- Current salary only
      AND emp.activo = TRUE          -- Active employees only
    GROUP BY dep.id_departamento
),

-- =====================================================
-- CTE 2: Employee Count per Department
-- =====================================================
-- Purpose: Count active employees in each department
-- Used to filter departments with sufficient size (>3 employees)
-- =====================================================
tab_cont_emp AS (
    SELECT
        id_departamento,
        COUNT(*) AS total_empleados_dept
    FROM empleados
    WHERE activo = TRUE
    GROUP BY id_departamento
),

-- =====================================================
-- CTE 3: Salary Ranking within Departments
-- =====================================================
-- Purpose: Rank employees by salary within their department
-- Technique: DENSE_RANK() to handle ties without gaps
-- =====================================================
tab_ranking_sueldo AS (
    SELECT
        emp.id_empleado,
        dep.id_departamento,
        sal.salario,
        DENSE_RANK() OVER(
            PARTITION BY dep.id_departamento 
            ORDER BY sal.salario DESC
        ) AS rnk_sueldo
    FROM empleados emp
    INNER JOIN salarios sal 
        ON emp.id_empleado = sal.id_empleado
    INNER JOIN departamentos dep
        ON emp.id_departamento = dep.id_departamento
    WHERE sal.fecha_fin IS NULL
      AND emp.activo = TRUE
),

-- =====================================================
-- CTE 4: Final Result Set
-- =====================================================
-- Purpose: Combine all CTEs and apply business filters
-- Joins all previous CTEs to build complete dataset
-- =====================================================
tab_final AS (
    SELECT
        dep.nombre AS nombre_departamento,
        tspd.prom_salario_dept AS salario_promedio_dept,
        tbce.total_empleados_dept,
        emp.nombre AS nombre_empleado,
        tbrs.salario AS salario_empleado,
        tbrs.rnk_sueldo
    FROM tab_ranking_sueldo tbrs
    INNER JOIN empleados emp 
        ON tbrs.id_empleado = emp.id_empleado
    INNER JOIN departamentos dep 
        ON tbrs.id_departamento = dep.id_departamento
    INNER JOIN tab_sal_prom_dept tspd 
        ON dep.id_departamento = tspd.id_departamento
    INNER JOIN tab_cont_emp tbce 
        ON dep.id_departamento = tbce.id_departamento
    WHERE tspd.prom_salario_dept > 60000    -- Business rule: high-paying depts
      AND tbce.total_empleados_dept > 3     -- Business rule: sufficient size
)

-- =====================================================
-- Final Query: Filter for Top 3 and Display
-- =====================================================
SELECT *
FROM tab_final
WHERE rnk_sueldo <= 3
ORDER BY nombre_departamento, rnk_sueldo;

-- =====================================================
-- EXPECTED OUTPUT STRUCTURE:
-- =====================================================
-- nombre_departamento | salario_promedio_dept | total_empleados_dept | 
-- nombre_empleado | salario_empleado | rnk_sueldo
--
-- Engineering         | 87500.00              | 5                    |
-- Emily Zhang         | 112000.00             | 1
-- James Carter        | 110000.00             | 2
-- Sofia Reyes         | 75000.00              | 3
-- ...
--
-- =====================================================
-- PERFORMANCE NOTES:
-- =====================================================
-- - All CTEs use proper JOIN conditions
-- - Filtering happens early (WHERE clauses in CTEs)
-- - Window function applied only to active employees
-- - Final filter on ranking happens after all JOINs
--
-- For very large datasets (100K+ employees):
-- - Consider adding indexes on: id_departamento, activo, fecha_fin
-- - Consider materializing CTEs as temp tables
-- - Monitor execution plan for full table scans
--
-- =====================================================
-- ALTERNATIVE APPROACHES:
-- =====================================================
-- 1. Subqueries: More nested, harder to read
-- 2. Temp Tables: Better for very large datasets
-- 3. Single query: Harder to debug and maintain
--
-- CTEs chosen for: readability, maintainability, testability
-- =====================================================
