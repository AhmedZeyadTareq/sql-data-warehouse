USE DataWarehouse;
GO

/* Create table if not exists */
IF OBJECT_ID('silver.ug_enrollment_clean', 'U') IS NULL
BEGIN
    CREATE TABLE silver.ug_enrollment_clean
    (
        term_code        varchar(50),
        term_name        varchar(100),
        career           varchar(50),
        college          varchar(150),
        program          varchar(150),
        student_id       varchar(50),
        student_name     nvarchar(200),
        subject          varchar(100),
        units_taken      varchar(50),   -- ✅ kept as-is (string)
        gender           varchar(20),
        source_file      varchar(50),
        load_datetime    datetime,
        is_valid         bit
    );
END
GO

/* Reload data */
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

FROM bronze.sis_full_ug_enr;
GO

-- Validation: Sample data
SELECT TOP 100 * FROM silver.ug_enrollment_clean;

-- Validation: Record counts
SELECT COUNT(*) FROM bronze.sis_full_ug_enr;
SELECT COUNT(*) FROM silver.ug_enrollment_clean;


