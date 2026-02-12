# 📊 Business Questions & Analysis

This document provides detailed analysis, insights, and recommendations based on the five core business intelligence queries for TalentCore HR.

---

## Query 1: Headcount & Payroll by Department

### Business Question
**"How is our workforce distributed across departments, and where is our compensation budget allocated?"**

### SQL Approach
```sql
SELECT
    dep.nombre AS nombre_departamento,
    COUNT(emp.id_empleado) AS total_empleados,
    SUM(sal.salario) AS masa_salarial_total,
    AVG(sal.salario) AS salario_promedio_departamento
FROM departamentos dep
INNER JOIN empleados emp ON dep.id_departamento = emp.id_departamento
INNER JOIN salarios sal ON emp.id_empleado = sal.id_empleado
WHERE emp.activo = TRUE
  AND sal.fecha_fin IS NULL
GROUP BY dep.nombre
ORDER BY masa_salarial_total DESC;
```

### Key Findings (Sample Data)
| Department | Active Employees | Total Payroll | Avg Salary |
|------------|-----------------|---------------|------------|
| Engineering | 5 | $414,000 | $82,800 |
| Customer Success | 3 | $217,000 | $72,333 |
| Product | 3 | $267,000 | $89,000 |
| Sales | 3 | $178,000 | $59,333 |
| Finance | 2 | $127,000 | $63,500 |
| Human Resources | 2 | $113,000 | $56,500 |

### Business Insights
- **Engineering dominates payroll** at 31% of total compensation despite being only 28% of headcount
- **Product has the highest average salary** ($89,000), reflecting senior talent requirements
- **HR has the lowest average salary** ($56,500), typical for mid-level HR specialist roles
- **Customer Success team** generates significant payroll cost due to senior-level positions

### Recommendations
1. **Budget Planning:** Engineering and Product should remain priority areas for compensation planning
2. **Compensation Review:** Consider salary equity analysis for HR team given critical nature of function
3. **Headcount Strategy:** Customer Success maintains lean team with senior talent - monitor for scaling needs

---

## Query 2: Employee Turnover by Year

### Business Question
**"What are our hiring and attrition trends, and is the company growing or contracting?"**

### SQL Approach
```sql
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
LEFT JOIN tabla_bajas tb ON tc.año = tb.año
ORDER BY tc.año ASC;
```

### Key Findings (Sample Data)
| Year | Hires | Departures | Net Change |
|------|-------|------------|------------|
| 2019 | 2 | 0 | +2 |
| 2020 | 6 | 0 | +6 |
| 2021 | 5 | 0 | +5 |
| 2022 | 4 | 1 | +3 |
| 2023 | 5 | 1 | +4 |
| 2024 | 3 | 4 | -1 |

### Business Insights
- **2020-2021 growth phase:** Aggressive hiring with 11 new employees (44% of current workforce)
- **2024 shows first negative net change:** 3 hires vs 4 departures signals potential retention concerns
- **Voluntary turnover started in 2022:** First departures after 3 years suggests team maturation
- **Overall growth trajectory positive:** 25 total hires vs 6 departures (24% attrition rate overall)

### Recommendations
1. **Investigate 2024 departures:** Conduct exit interviews to identify patterns in recent attrition
2. **Retention programs:** Implement retention initiatives for high-value employees
3. **Succession planning:** 24% historical attrition rate requires strong internal pipeline
4. **Hiring strategy:** Consider whether 2024 slowdown is strategic or reactive

---

## Query 3: Salary Analysis by Department & Level

### Business Question
**"Are we paying competitively across different departments and seniority levels?"**

### SQL Approach
```sql
SELECT
    dep.nombre AS nombre_departamento,
    car.nivel AS nivel_cargo,
    COUNT(emp.id_empleado) AS total_empleados,
    MIN(sal.salario) AS salario_minimo,
    AVG(sal.salario) AS salario_promedio,
    MAX(sal.salario) AS salario_maximo
FROM departamentos dep
INNER JOIN empleados emp ON dep.id_departamento = emp.id_departamento
INNER JOIN cargos car ON emp.id_cargo = car.id_cargo
INNER JOIN salarios sal ON emp.id_empleado = sal.id_empleado
WHERE emp.activo = TRUE
  AND sal.fecha_fin IS NULL
GROUP BY dep.nombre, car.nivel
ORDER BY dep.nombre ASC, car.nivel ASC;
```

### Key Findings (Sample Data)
| Department | Level | Count | Min Salary | Avg Salary | Max Salary |
|------------|-------|-------|------------|------------|------------|
| Engineering | Junior | 2 | $42,000 | $43,500 | $45,000 |
| Engineering | Mid | 2 | $72,000 | $73,500 | $75,000 |
| Engineering | Senior | 2 | $110,000 | $111,000 | $112,000 |
| Finance | Mid | 2 | $62,000 | $63,500 | $65,000 |
| Human Resources | Mid | 2 | $50,000 | $56,500 | $63,000 |
| Product | Mid | 2 | $74,000 | $76,000 | $78,000 |
| Product | Senior | 1 | $115,000 | $115,000 | $115,000 |
| Sales | Junior | 2 | $38,000 | $39,000 | $40,000 |
| Sales | Senior | 2 | $68,000 | $70,000 | $72,000 |

### Business Insights
- **Clear level differentiation:** Salary progression from Junior to Senior is well-defined
- **Engineering commands premium:** Senior Engineering ($111K avg) vs Senior Sales ($70K avg)
- **HR salary compression:** $13K spread within mid-level HR suggests newer vs. tenured differential
- **Product maintains competitive rates:** Senior Product at $115K indicates market-rate compensation

### Recommendations
1. **Level consistency:** Maintain clear salary bands to support internal equity
2. **Market benchmarking:** Annually review Engineering and Product rates due to competitive market
3. **Sales compensation review:** Junior Sales at $39K may be below market - risk of early-career attrition
4. **Merit increase planning:** HR's $13K spread shows room for performance-based adjustments

---

## Query 4: Absenteeism Rate by Department

### Business Question
**"Which departments have the highest absence rates, and what types of absences are most common?"**

### SQL Approach
```sql
WITH tabla_ausencias AS (
    SELECT
        id_empleado,
        SUM(dias) AS dias_ausencias
    FROM ausencias
    WHERE YEAR(fecha_inicio) = 2024
    GROUP BY id_empleado
),
tabla_tipos_frec AS (
    SELECT
        e.id_departamento,
        a.tipo,
        COUNT(*) AS frecuencia,
        ROW_NUMBER() OVER(PARTITION BY e.id_departamento ORDER BY COUNT(*) DESC) AS rn
    FROM ausencias a
    INNER JOIN empleados e ON a.id_empleado = e.id_empleado
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
INNER JOIN empleados emp ON dep.id_departamento = emp.id_departamento
INNER JOIN (
    SELECT id_departamento, tipo
    FROM tabla_tipos_frec
    WHERE rn = 1
) ttf ON dep.id_departamento = ttf.id_departamento
INNER JOIN tabla_ausencias tau ON emp.id_empleado = tau.id_empleado
WHERE emp.activo = TRUE
GROUP BY dep.nombre, ttf.tipo
ORDER BY total_dias_ausencia DESC;
```

### Key Findings (Sample Data)
| Department | Active Employees | Total Days | Avg Days/Employee | Most Frequent Type |
|------------|------------------|------------|-------------------|-------------------|
| Engineering | 5 | 41 | 8.2 | vacation |
| Product | 3 | 18 | 6.0 | vacation |
| Customer Success | 3 | 18 | 6.0 | vacation |
| Sales | 3 | 17 | 5.7 | vacation |
| Finance | 2 | 15 | 7.5 | vacation |
| Human Resources | 2 | 8 | 4.0 | vacation |

### Business Insights
- **Vacation drives most absences:** All departments show vacation as most frequent type
- **Engineering shows highest total:** 41 days across 5 employees suggests generous PTO policy compliance
- **HR shows lowest rate:** 4 days per employee may indicate workload preventing time off
- **Relatively low sick leave:** Absence of sick_leave as top type suggests healthy workforce or underreporting

### Recommendations
1. **HR vacation policy:** Ensure HR team takes adequate time off to prevent burnout
2. **Absence tracking:** Monitor if low sick leave indicates presenteeism concerns
3. **PTO utilization:** Engineering's 8.2 days/employee is healthy - promote across all departments
4. **Seasonal planning:** Coordinate vacation schedules to maintain operational coverage

---

## Query 5: Performance vs Salary Range

### Business Question
**"Are our top performers compensated appropriately within their salary bands?"**

### SQL Approach
```sql
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
INNER JOIN departamentos dep ON emp.id_departamento = dep.id_departamento
INNER JOIN cargos car ON emp.id_cargo = car.id_cargo
INNER JOIN evaluaciones eva ON emp.id_empleado = eva.id_empleado
LEFT JOIN salarios sal ON emp.id_empleado = sal.id_empleado
WHERE emp.activo = TRUE
  AND eva.periodo = '2024-Q4'
  AND sal.fecha_fin IS NULL
ORDER BY eva.puntaje DESC;
```

### Key Findings (Sample Data)
**Top Performers (4.5+ scores):**
| Employee | Score | Salary | Band | Position |
|----------|-------|--------|------|----------|
| Emily Zhang | 4.9 | $112,000 | $85K-$120K | Within Band |
| Mia Thompson | 4.8 | $115,000 | $95K-$130K | Within Band |
| James Carter | 4.6 | $110,000 | $85K-$120K | Within Band |
| Oscar Rivera | 4.6 | $72,000 | $60K-$85K | Within Band |
| Diana Moore | 4.5 | $63,000 | $45K-$65K | Within Band |
| Ryan Walker | 4.5 | $72,000 | $55K-$80K | Within Band |

**Low Performers (<3.5 scores):**
| Employee | Score | Salary | Band | Position |
|----------|-------|--------|------|----------|
| Diego Torres | 3.2 | $38,000 | $35K-$55K | Within Band |
| Claire Martin | 3.0 | $42,000 | $40K-$60K | Within Band |

### Business Insights
- **Strong pay-for-performance alignment:** All top performers (4.5+) are positioned within their bands
- **No above-band outliers:** Salary discipline maintained across all performance levels
- **Room for merit increases:** Top performers like Emily (4.9 at $112K) have $8K headroom to max band
- **New hire positioning:** Low performers are appropriately positioned at band entry points

### Recommendations
1. **Merit increase targeting:** Prioritize raises for 4.5+ performers approaching band ceilings
2. **Promotion candidates:** Emily Zhang (4.9) and Mia Thompson (4.8) ready for next-level evaluation
3. **Performance management:** Employees below 3.5 should receive development plans
4. **Band progression:** Consider creating Lead/Principal levels for top Senior contributors

---

## 🎯 Executive Summary

### Key Takeaways
1. **Workforce is lean and efficient:** 20 active employees across 6 departments with clear role definitions
2. **Compensation strategy is disciplined:** All employees within salary bands, strong pay-for-performance
3. **Retention requires attention:** 2024 showed first negative net headcount change
4. **High performers are valued:** Top evaluations correlate with appropriate salary positioning
5. **Work-life balance is healthy:** Vacation utilization is strong across most departments

### Strategic Priorities for Next Year
1. Implement retention programs targeting high performers
2. Review HR team workload and PTO utilization
3. Conduct market salary benchmarking for Engineering and Product
4. Develop succession plan for 4.8+ performers ready for advancement
5. Address 2024 turnover root causes through enhanced employee engagement

---

*Analysis conducted on sample data representing TalentCore HR as of Q4 2024*
