USE DataWarehouse;
GO

DROP TABLE IF EXISTS gold.ug_term_fte_count;
CREATE TABLE gold.ug_term_fte_count (
    term_name NVARCHAR(100),
    fte_students INT,
    load_datetime DATETIME
);


DROP TABLE IF EXISTS gold.ug_term_student_count;
CREATE TABLE gold.ug_term_student_count (
    term_name NVARCHAR(100),
    unique_students INT,
    load_datetime DATETIME
);


DROP TABLE IF EXISTS gold.ug_term_summary;
CREATE TABLE gold.ug_term_summary (
    term_name NVARCHAR(100),
    total_students INT,
    fte_students INT,
    load_datetime DATETIME
);
