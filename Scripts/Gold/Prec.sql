CREATE OR ALTER PROCEDURE gold.load_ug_students_results AS
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

EXEC gold.load_ug_term_student_count;

SELECT * FROM gold.ug_term_student_count;
