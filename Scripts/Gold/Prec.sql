CREATE TABLE gold.ug_term_fte_count (
    term_name NVARCHAR(100),
    fte_students INT,
    load_datetime DATETIME
);

CREATE OR ALTER PROCEDURE gold.load_ug_term_fte_count AS
BEGIN
    TRUNCATE TABLE gold.ug_term_fte_count;

    INSERT INTO gold.ug_term_fte_count
    (
        term_name,
        fte_students,
        load_datetime
    )
    SELECT
        term_name,
        COUNT(*) AS fte_students,
        GETDATE()
    FROM silver.ug_student_term
    WHERE is_fte = 1
    GROUP BY term_name;
END;

EXEC gold.load_ug_term_fte_count;

SELECT * FROM gold.ug_term_fte_count;
