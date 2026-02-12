-- ============================================================
-- TalentCore HR - People Analytics Database
-- Sample Data: INSERTs
-- ============================================================

USE talentcore_hr;

-- ------------------------------------------------------------
-- departamentos (6 records)
-- ------------------------------------------------------------
INSERT INTO departamentos (nombre, ubicacion, activo) VALUES
('Engineering',       'Floor 3', TRUE),
('Product',           'Floor 3', TRUE),
('Sales',             'Floor 2', TRUE),
('Human Resources',   'Floor 1', TRUE),
('Finance',           'Floor 1', TRUE),
('Customer Success',  'Floor 2', TRUE);

-- ------------------------------------------------------------
-- cargos (10 records)
-- ------------------------------------------------------------
INSERT INTO cargos (titulo, nivel, banda_min, banda_max) VALUES
('Software Engineer',       'Junior',  40000.00,  60000.00),
('Software Engineer',       'Mid',     60000.00,  85000.00),
('Software Engineer',       'Senior',  85000.00, 120000.00),
('Product Manager',         'Mid',     70000.00,  95000.00),
('Product Manager',         'Senior',  95000.00, 130000.00),
('Sales Representative',    'Junior',  35000.00,  55000.00),
('Sales Representative',    'Senior',  55000.00,  80000.00),
('HR Specialist',           'Mid',     45000.00,  65000.00),
('Financial Analyst',       'Mid',     55000.00,  75000.00),
('Customer Success Manager','Senior',  60000.00,  85000.00);

-- ------------------------------------------------------------
-- empleados (25 records — mix of active and former)
-- ------------------------------------------------------------
INSERT INTO empleados (nombre, apellido, email, id_departamento, id_cargo, fecha_ingreso, fecha_salida, activo) VALUES
-- Engineering
('James',   'Carter',   'james.carter@talentcore.com',   1, 3, '2020-03-15', NULL,         TRUE),
('Sofia',   'Reyes',    'sofia.reyes@talentcore.com',    1, 2, '2021-07-01', NULL,         TRUE),
('Nathan',  'Brooks',   'nathan.brooks@talentcore.com',  1, 1, '2022-09-12', NULL,         TRUE),
('Emily',   'Zhang',    'emily.zhang@talentcore.com',    1, 3, '2019-11-20', NULL,         TRUE),
('Lucas',   'Petrov',   'lucas.petrov@talentcore.com',   1, 2, '2023-01-10', '2024-08-31', FALSE),
-- Product
('Mia',     'Thompson', 'mia.thompson@talentcore.com',   2, 5, '2020-06-01', NULL,         TRUE),
('Carlos',  'Mendez',   'carlos.mendez@talentcore.com',  2, 4, '2022-03-14', NULL,         TRUE),
('Aisha',   'Nkosi',    'aisha.nkosi@talentcore.com',    2, 4, '2021-08-22', '2024-05-15', FALSE),
-- Sales
('Ryan',    'Walker',   'ryan.walker@talentcore.com',    3, 7, '2020-02-10', NULL,         TRUE),
('Priya',   'Singh',    'priya.singh@talentcore.com',    3, 6, '2023-04-03', NULL,         TRUE),
('Tom',     'Harris',   'tom.harris@talentcore.com',     3, 6, '2022-11-01', '2024-03-31', FALSE),
('Lucia',   'Fernandez','lucia.fernandez@talentcore.com',3, 7, '2021-05-17', NULL,         TRUE),
-- Human Resources
('Diana',   'Moore',    'diana.moore@talentcore.com',    4, 8, '2019-08-05', NULL,         TRUE),
('Kevin',   'Lee',      'kevin.lee@talentcore.com',      4, 8, '2022-06-20', NULL,         TRUE),
-- Finance
('Sandra',  'White',    'sandra.white@talentcore.com',   5, 9, '2020-10-12', NULL,         TRUE),
('Mark',    'Johnson',  'mark.johnson@talentcore.com',   5, 9, '2021-03-08', NULL,         TRUE),
('Nina',    'Patel',    'nina.patel@talentcore.com',     5, 9, '2023-07-19', '2024-11-30', FALSE),
-- Customer Success
('Oscar',   'Rivera',   'oscar.rivera@talentcore.com',   6, 10,'2020-09-01', NULL,         TRUE),
('Hannah',  'Scott',    'hannah.scott@talentcore.com',   6, 10,'2021-12-15', NULL,         TRUE),
('Ethan',   'Kim',      'ethan.kim@talentcore.com',      6, 10,'2022-04-25', NULL,         TRUE),
('Zoe',     'Adams',    'zoe.adams@talentcore.com',      6, 10,'2023-02-07', '2024-07-31', FALSE),
-- Additional Engineering
('Raj',     'Sharma',   'raj.sharma@talentcore.com',     1, 2, '2023-08-14', NULL,         TRUE),
('Claire',  'Martin',   'claire.martin@talentcore.com',  1, 1, '2024-01-08', NULL,         TRUE),
-- Additional Sales
('Diego',   'Torres',   'diego.torres@talentcore.com',   3, 6, '2024-03-01', NULL,         TRUE),
-- Additional Product
('Lily',    'Chen',     'lily.chen@talentcore.com',      2, 4, '2024-05-20', NULL,         TRUE);

-- ------------------------------------------------------------
-- salarios (30 records — some employees have history)
-- ------------------------------------------------------------
INSERT INTO salarios (id_empleado, salario, fecha_inicio, fecha_fin) VALUES
-- James Carter (raised in 2023)
(1,  95000.00, '2020-03-15', '2023-02-28'),
(1, 110000.00, '2023-03-01', NULL),
-- Sofia Reyes
(2,  68000.00, '2021-07-01', '2023-06-30'),
(2,  75000.00, '2023-07-01', NULL),
-- Nathan Brooks
(3,  45000.00, '2022-09-12', NULL),
-- Emily Zhang
(4, 112000.00, '2019-11-20', NULL),
-- Lucas Petrov (left)
(5,  65000.00, '2023-01-10', '2024-08-31'),
-- Mia Thompson
(6, 115000.00, '2020-06-01', NULL),
-- Carlos Mendez
(7,  78000.00, '2022-03-14', NULL),
-- Aisha Nkosi (left)
(8,  72000.00, '2021-08-22', '2024-05-15'),
-- Ryan Walker
(9,  72000.00, '2020-02-10', NULL),
-- Priya Singh
(10, 40000.00, '2023-04-03', NULL),
-- Tom Harris (left)
(11, 48000.00, '2022-11-01', '2024-03-31'),
-- Lucia Fernandez
(12, 68000.00, '2021-05-17', NULL),
-- Diana Moore
(13, 58000.00, '2019-08-05', '2022-07-31'),
(13, 63000.00, '2022-08-01', NULL),
-- Kevin Lee
(14, 50000.00, '2022-06-20', NULL),
-- Sandra White
(15, 62000.00, '2020-10-12', NULL),
-- Mark Johnson
(16, 65000.00, '2021-03-08', NULL),
-- Nina Patel (left)
(17, 58000.00, '2023-07-19', '2024-11-30'),
-- Oscar Rivera
(18, 72000.00, '2020-09-01', NULL),
-- Hannah Scott
(19, 75000.00, '2021-12-15', NULL),
-- Ethan Kim
(20, 70000.00, '2022-04-25', NULL),
-- Zoe Adams (left)
(21, 68000.00, '2023-02-07', '2024-07-31'),
-- Raj Sharma
(22, 72000.00, '2023-08-14', NULL),
-- Claire Martin
(23, 42000.00, '2024-01-08', NULL),
-- Diego Torres
(24, 38000.00, '2024-03-01', NULL),
-- Lily Chen
(25, 74000.00, '2024-05-20', NULL);

-- ------------------------------------------------------------
-- ausencias (35 records)
-- ------------------------------------------------------------
INSERT INTO ausencias (id_empleado, tipo, fecha_inicio, fecha_fin, dias) VALUES
(1,  'vacation',    '2024-01-08', '2024-01-12', 5),
(1,  'sick_leave',  '2024-06-03', '2024-06-04', 2),
(2,  'vacation',    '2024-02-19', '2024-02-23', 5),
(2,  'personal',    '2024-09-10', '2024-09-10', 1),
(3,  'sick_leave',  '2024-03-05', '2024-03-07', 3),
(4,  'vacation',    '2024-07-15', '2024-07-26', 10),
(5,  'sick_leave',  '2024-04-22', '2024-04-23', 2),
(6,  'vacation',    '2024-08-05', '2024-08-16', 10),
(7,  'personal',    '2024-05-06', '2024-05-06', 1),
(7,  'sick_leave',  '2024-11-18', '2024-11-19', 2),
(8,  'vacation',    '2024-01-29', '2024-02-02', 5),
(9,  'vacation',    '2024-03-18', '2024-03-22', 5),
(9,  'sick_leave',  '2024-10-07', '2024-10-09', 3),
(10, 'personal',    '2024-06-14', '2024-06-14', 1),
(11, 'sick_leave',  '2024-02-12', '2024-02-14', 3),
(12, 'vacation',    '2024-09-02', '2024-09-13', 10),
(13, 'vacation',    '2024-04-01', '2024-04-05', 5),
(13, 'personal',    '2024-11-04', '2024-11-04', 1),
(14, 'sick_leave',  '2024-07-22', '2024-07-23', 2),
(15, 'vacation',    '2024-05-20', '2024-05-24', 5),
(15, 'unpaid',      '2024-10-14', '2024-10-18', 5),
(16, 'vacation',    '2024-08-19', '2024-08-23', 5),
(17, 'sick_leave',  '2024-03-11', '2024-03-13', 3),
(18, 'vacation',    '2024-06-24', '2024-06-28', 5),
(18, 'personal',    '2024-12-02', '2024-12-02', 1),
(19, 'vacation',    '2024-01-22', '2024-01-26', 5),
(19, 'sick_leave',  '2024-09-16', '2024-09-17', 2),
(20, 'vacation',    '2024-07-08', '2024-07-12', 5),
(21, 'sick_leave',  '2024-02-26', '2024-02-27', 2),
(22, 'vacation',    '2024-10-21', '2024-10-25', 5),
(22, 'personal',    '2024-12-09', '2024-12-09', 1),
(23, 'sick_leave',  '2024-05-13', '2024-05-14', 2),
(24, 'personal',    '2024-11-25', '2024-11-25', 1),
(25, 'vacation',    '2024-08-26', '2024-08-30', 5),
(13, 'sick_leave',  '2024-08-12', '2024-08-13', 2);

-- ------------------------------------------------------------
-- evaluaciones (40 records — 2023 and 2024 cycles)
-- ------------------------------------------------------------
INSERT INTO evaluaciones (id_empleado, periodo, puntaje, comentarios) VALUES
-- 2023 cycle
(1,  '2023-Q4', 4.5, 'Excellent technical leadership'),
(2,  '2023-Q4', 4.0, 'Strong contributor, good teamwork'),
(3,  '2023-Q4', 3.2, 'Meeting expectations, room to grow'),
(4,  '2023-Q4', 4.8, 'Outstanding performance'),
(5,  '2023-Q4', 3.0, 'Average performance'),
(6,  '2023-Q4', 4.7, 'Exceptional product vision'),
(7,  '2023-Q4', 3.8, 'Good execution on roadmap'),
(8,  '2023-Q4', 3.5, 'Solid contributor'),
(9,  '2023-Q4', 4.2, 'Top sales performer'),
(10, '2023-Q4', 3.0, 'New hire, learning curve'),
(11, '2023-Q4', 2.8, 'Below expectations'),
(12, '2023-Q4', 4.0, 'Consistent high performer'),
(13, '2023-Q4', 4.3, 'Great HR leadership'),
(14, '2023-Q4', 3.6, 'Reliable and organized'),
(15, '2023-Q4', 4.1, 'Strong analytical skills'),
(16, '2023-Q4', 3.9, 'Good team player'),
(17, '2023-Q4', 3.4, 'Developing well'),
(18, '2023-Q4', 4.4, 'Customer champion'),
(19, '2023-Q4', 4.2, 'Proactive and client-focused'),
(20, '2023-Q4', 3.7, 'Solid performance'),
-- 2024 cycle
(1,  '2024-Q4', 4.6, 'Continued strong leadership'),
(2,  '2024-Q4', 4.2, 'Growth in technical depth'),
(3,  '2024-Q4', 3.5, 'Improving steadily'),
(4,  '2024-Q4', 4.9, 'Best engineer on team'),
(6,  '2024-Q4', 4.8, 'Exceptional year'),
(7,  '2024-Q4', 4.0, 'Promoted-ready'),
(9,  '2024-Q4', 4.5, 'Record sales quarter'),
(10, '2024-Q4', 3.8, 'Noticeable improvement'),
(12, '2024-Q4', 4.1, 'Reliable performer'),
(13, '2024-Q4', 4.5, 'HR process improvements'),
(14, '2024-Q4', 3.8, 'Growing into role'),
(15, '2024-Q4', 4.3, 'Led budget process'),
(16, '2024-Q4', 4.0, 'Strong year'),
(18, '2024-Q4', 4.6, 'Outstanding NPS scores'),
(19, '2024-Q4', 4.4, 'Key account wins'),
(20, '2024-Q4', 3.9, 'Consistent delivery'),
(22, '2024-Q4', 3.7, 'Good first year'),
(23, '2024-Q4', 3.0, 'Still onboarding'),
(24, '2024-Q4', 3.2, 'Early stage, promising'),
(25, '2024-Q4', 4.0, 'Strong product instincts');
