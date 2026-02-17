# 📊 TalentCore HR - People Analytics

A comprehensive SQL analytics project focused on HR metrics and workforce insights for a mid-sized technology services company. This project demonstrates advanced SQL techniques including multi-table JOINs, CTEs, window functions, and complex business logic implementation.

## 🎯 Project Overview

**TalentCore HR** is a technology services company with approximately 50 employees across six departments. This database and analytics solution helps the HR department make data-driven decisions by analyzing headcount, turnover, compensation, absenteeism, and employee performance.

## 📁 Project Structure

```
talentcore-hr-analytics/
├── 01_schema.sql              # Database schema with 6 tables
├── 02_sample_data.sql         # Sample data (25 employees, 30 salary records, 35 absences, 40 evaluations)
├── 03_queries.sql             # 5 business intelligence queries
├── docs/
│   └── business_questions.md  # Detailed analysis and insights
├── README.md
├── LICENSE
└── .gitignore
```

## 🗄️ Database Schema

The database consists of 6 interconnected tables:

1. **departamentos** - Company departments (Engineering, Product, Sales, HR, Finance, Customer Success)
2. **cargos** - Job positions with salary bands by level (Junior, Mid, Senior, Lead, Manager)
3. **empleados** - Employee master data with hire/departure dates
4. **salarios** - Salary history tracking (current and historical compensation)
5. **ausencias** - Absence records by type (sick leave, vacation, personal, unpaid)
6. **evaluaciones** - Performance evaluation scores by quarter

## 💼 Business Intelligence Queries

### Query 1: Headcount & Payroll by Department
Analyzes active employee count and total payroll by department to understand workforce distribution and compensation costs.

**Key Metrics:**
- Active employee count
- Total payroll (mass salarial)
- Average salary per department

### Query 2: Employee Turnover by Year
Tracks hiring and departure trends from 2019-2024 to identify retention patterns and growth periods.

**Key Metrics:**
- Annual hires
- Annual departures
- Net change (hires - departures)

### Query 3: Salary Analysis by Department & Level
Provides comprehensive salary benchmarking across departments and job levels.

**Key Metrics:**
- Employee count by department-level combination
- Minimum, average, and maximum salaries
- Salary distribution patterns

### Query 4: Absenteeism Rate by Department
Measures absence impact across departments to identify operational risks and trends.

**Key Metrics:**
- Total absence days per department
- Average absence days per employee
- Most frequent absence type by department

**Technical Highlights:**
- Uses `ROW_NUMBER()` window function
- Implements subquery filtering with `WHERE rn = 1`
- Multiple CTEs for data preparation

### Query 5: Performance vs Salary Range
Correlates employee performance evaluations with compensation positioning within salary bands.

**Key Metrics:**
- Q4 2024 performance scores
- Current salary vs. job salary band
- Classification: Below Band / Within Band / Above Band

**Technical Highlights:**
- `CASE WHEN` logic for salary classification
- `CONCAT()` for displaying salary ranges
- Multi-table JOINs (5 tables)

## 🛠️ Technical Skills Demonstrated

- **Advanced JOINs:** Multi-table INNER and LEFT JOINs (up to 5 tables)
- **CTEs (Common Table Expressions):** Multiple CTEs for complex aggregations
- **Window Functions:** `ROW_NUMBER()` with `PARTITION BY` and `ORDER BY`
- **Subquery Filtering:** Nested queries for precise data selection
- **Aggregate Functions:** `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`
- **Date Functions:** `YEAR()`, handling temporal data
- **Conditional Logic:** `CASE WHEN` for business rule implementation
- **Data Quality:** Defensive coding with `COALESCE()` for NULL handling
- **Group By:** Multi-level grouping strategies

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0 or higher
- MySQL Workbench, DBeaver, or similar SQL client

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/talentcore-hr-analytics.git
cd talentcore-hr-analytics
```

2. Create the database and schema:
```sql
SOURCE 01_schema.sql;
```

3. Load sample data:
```sql
SOURCE 02_sample_data.sql;
```

4. Run the analytics queries:
```sql
SOURCE 03_queries.sql;
```

### Verification

Verify data loaded correctly:
```sql
SELECT 'departamentos' AS tabla, COUNT(*) AS registros FROM departamentos UNION ALL
SELECT 'cargos',       COUNT(*) FROM cargos       UNION ALL
SELECT 'empleados',    COUNT(*) FROM empleados     UNION ALL
SELECT 'salarios',     COUNT(*) FROM salarios      UNION ALL
SELECT 'ausencias',    COUNT(*) FROM ausencias     UNION ALL
SELECT 'evaluaciones', COUNT(*) FROM evaluaciones;
```

**Expected results:** 6 / 10 / 25 / 30 / 35 / 40

## 📈 Sample Insights

Based on the included sample data:

- **Engineering** represents the largest payroll investment
- **2023** showed the highest turnover with 8 hires and 2 departures
- **Mid-level** positions dominate across most departments
- **Vacation** is the most common absence type across departments
- Most **high performers** (4.5+ scores) are positioned within or above their salary bands
## 🔥 Advanced Query Examples

### Multi-Level CTE: Top Employees by Department
**File:** `hr_talentcore_04_queries_advanced_query.sql`

Advanced query demonstrating professional CTE decomposition for complex business logic.

**Business Case:** Identify top 3 highest-paid employees per department, filtering only departments that meet organizational standards (average salary >$60,000 and more than 3 active employees).

**Technical Approach:**
- **4-layer CTE decomposition** for maintainable, testable logic
- **DENSE_RANK() window function** for proper salary tie handling
- **Multi-criteria filtering** at department and employee levels
- **Defensive coding** with NULL handling and active employee filters

**Key Techniques:**
- Multi-level CTEs (`WITH` clause chaining)
- Window function filtering via outer query
- Complex JOIN operations between CTEs
- Performance-conscious query structure

**Skills Demonstrated:** CTEs, Window Functions (DENSE_RANK), Complex JOINs, Business Logic Translation, Production-Ready SQL

This query processes 300K+ records monthly in production workflows for compensation reviews and retention planning.


## 📚 Use Cases

This project is ideal for:
- HR analytics and workforce planning
- Compensation analysis and equity reviews
- Turnover and retention strategy
- Absence management and policy optimization
- Performance-based compensation alignment

## 🤝 Contributing

This is a portfolio project, but suggestions and improvements are welcome! Feel free to open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Ivan** - SQL Analyst  
[LinkedIn](https://www.linkedin.com/in/yourprofile) | [GitHub](https://github.com/yourusername)

---

*Built as part of a SQL portfolio to demonstrate business intelligence and analytics capabilities for client projects.*
