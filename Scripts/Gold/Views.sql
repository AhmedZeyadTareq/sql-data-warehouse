PRINT 'CREATE VIEW: gold.ug_retained_fte';
GO

CREATE OR ALTER VIEW gold.ug_retained_fte AS
SELECT term_name,
       COUNT(DISTINCT student_id) AS total_students,
       COUNT(DISTINCT CASE WHEN is_fte = 1 THEN student_id END) AS total_fte_students,
       source_file
FROM silver.ug_student_term
GROUP BY term_name, source_file;
GO

PRINT 'DONE...';
PRINT '===============================';
GO


PRINT 'CREATE VIEW: gold.ug_cohort_fte';
GO

CREATE OR ALTER VIEW gold.ug_cohort_fte AS
SELECT started_year AS joined_year,
       term_name,
       COUNT(DISTINCT student_id) AS total_cohort_students,
       COUNT(DISTINCT CASE WHEN is_fte = 1 THEN student_id END) AS total_cohort_fte_students
FROM silver.ug_student_term
GROUP BY started_year, term_name;
GO

PRINT 'DONE...';
PRINT '===============================';
GO


PRINT 'CREATE VIEW: gold.ug_by_college_fte';
GO

CREATE OR ALTER VIEW gold.ug_by_college_fte AS
SELECT college,
       term_name,
       COUNT(DISTINCT student_id) AS total_students,
       COUNT(DISTINCT CASE WHEN is_fte = 1 THEN student_id END) AS total_fte_students
FROM silver.ug_student_term
GROUP BY college, term_name;
GO

PRINT 'DONE...';
PRINT '===============================';
GO


PRINT 'CREATE VIEW: gold.ug_by_program_fte';
GO

CREATE OR ALTER VIEW gold.ug_by_program_fte AS
SELECT college,
       program,
       term_name,
       COUNT(DISTINCT student_id) AS total_students,
       COUNT(DISTINCT CASE WHEN is_fte = 1 THEN student_id END) AS total_fte_students
FROM silver.ug_student_term
GROUP BY college, program, term_name;
GO

PRINT 'DONE...';
PRINT '===============================';
GO
