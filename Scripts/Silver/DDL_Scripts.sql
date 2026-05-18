USE DataWarehouse;
GO


DROP TABLE IF EXISTS silver.ug_enrollment_clean;

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




DROP TABLE IF EXISTS silver.ug_student_term;

CREATE TABLE silver.ug_student_term
    (
        term_code        varchar(50),
        term_name        varchar(100),   -- ✅ added

        student_id       varchar(50),
        student_name     nvarchar(200),
        gender           varchar(20),
        college          varchar(150),
        program          varchar(150),

        total_courses    int,
        total_units      decimal(5,2),

        is_fte           bit,

        source_file      varchar(50),
        load_datetime    datetime
    );
