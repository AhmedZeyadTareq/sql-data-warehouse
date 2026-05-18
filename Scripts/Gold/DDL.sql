CREATE TABLE gold.ug_term_student_count (
    term_name NVARCHAR(100),
    unique_students INT,
    load_datetime DATETIME
);


CREATE OR ALTER PROCEDURE gold.load_ug_term_student_count AS
BEGIN
    TRUNCATE TABLE gold.ug_term_student_count;

    INSERT INTO gold.ug_term_student_count
    (
        term_name,
        unique_students,
        load_datetime
    )
    SELECT
        term_name,
        COUNT(DISTINCT student_id) AS unique_students,
        GETDATE()
    FROM silver.ug_student_term
    GROUP BY term_name;
END;

EXEC gold.load_ug_term_student_count;

SELECT * FROM gold.ug_term_student_count;
