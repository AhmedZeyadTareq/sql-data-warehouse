TRUNCATE TABLE silver.ug_enrollment_clean;

INSERT INTO silver.ug_enrollment_clean
(
    term_code,
    term_name,
    career,
    college,
    program,
    student_id,
    student_name,
    subject,
    units_taken,
    gender,
    source_file,
    load_datetime,
    is_valid
)
SELECT
    LTRIM(RTRIM(Term_Code)),
    LTRIM(RTRIM(Term)),
    LTRIM(RTRIM(Career)),
    LTRIM(RTRIM(College)),
    LTRIM(RTRIM(Program)),
    LTRIM(RTRIM(Id)),
    LTRIM(RTRIM(Name)),
    LTRIM(RTRIM(Subject)),

    LTRIM(RTRIM(Unit_Taken)),   -- ✅ ONLY trim, no conversion

    CASE 
        WHEN UPPER(LTRIM(RTRIM(Gender))) IN ('M','MALE') THEN 'Male'
        WHEN UPPER(LTRIM(RTRIM(Gender))) IN ('F','FEMALE') THEN 'Female'
        ELSE 'Unknown'
    END,

    'sis_full_ug_enr',
    GETDATE(),

    CASE 
        WHEN Id IS NULL OR LTRIM(RTRIM(Id)) = '' THEN 0
        WHEN Term_Code IS NULL OR LTRIM(RTRIM(Term_Code)) = '' THEN 0
        WHEN Subject IS NULL OR LTRIM(RTRIM(Subject)) = '' THEN 0
        WHEN Unit_Taken IS NULL OR LTRIM(RTRIM(Unit_Taken)) = '' THEN 0  -- ✅ updated check
        ELSE 1
    END

TRUNCATE TABLE silver.ug_student_term;

INSERT INTO silver.ug_student_term
(
    term_code,
    term_name,      -- ✅ added

    student_id,
    student_name,
    gender,
    college,
    program,

    total_courses,
    total_units,
    is_fte,

    source_file,
    load_datetime
)
SELECT
    term_code,
    MAX(term_name),   -- ✅ bring from source

    student_id,
    MAX(student_name),
    MAX(gender),
    MAX(college),
    MAX(program),

    COUNT(*) AS total_courses,

    SUM(TRY_CAST(units_taken AS decimal(5,2))) AS total_units,

    CASE 
        WHEN SUM(TRY_CAST(units_taken AS decimal(5,2))) >= 12 THEN 1
        ELSE 0
    END AS is_fte,

    'sis_full_ug_enr',
    GETDATE()

FROM silver.ug_enrollment_clean
WHERE is_valid = 1
GROUP BY
    term_code,
    student_id;
    
FROM bronze.sis_full_ug_enr;
GO


