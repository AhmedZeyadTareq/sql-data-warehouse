CREATE TABLE gold.ug_term_summary (
    term_name NVARCHAR(100),
    total_students INT,
    fte_students INT,
    load_datetime DATETIME
);


CREATE OR ALTER PROCEDURE gold.load_ug_term_summary AS
BEGIN
    TRUNCATE TABLE gold.ug_term_summary;

    INSERT INTO gold.ug_term_summary
    (
        term_name,
        total_students,
        fte_students,
        load_datetime
    )
    SELECT
        term_name,
        COUNT(DISTINCT student_id) AS total_students,
        SUM(CASE WHEN is_fte = 1 THEN 1 ELSE 0 END) AS fte_students,
        GETDATE()
    FROM silver.ug_student_term
    GROUP BY term_name;
END;

EXEC gold.load_ug_term_summary;

SELECT * FROM gold.ug_term_summary;
