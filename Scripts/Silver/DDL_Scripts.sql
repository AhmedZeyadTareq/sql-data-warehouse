/*
### 📄 Brief Documentation

Purpose:
Create Silver tables for cleaned and aggregated enrollment data.

What it does:
- Drops and recreates two tables

Tables:

1. silver.ug_enrollment_clean
- Clean row-level data (1 row per student per subject)
- Includes student info, academic info, subject, units (string)
- Includes validation_key (used later for aggregation)
- Includes is_valid, source_file, load_datetime

2. silver.ug_student_term
- Aggregated data (1 row per student per term)
- started_year comes from validation_key
- Includes totals:
  - total_courses
  - total_units
  - is_fte (>= 12 units)

Warning:
Drops tables → deletes all data.

Why used:
Prepare clean and aggregated data for analysis.
*/


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
        units_taken      varchar(50), 
        gender           varchar(20),
        validation_key   varchar(20),
        source_file      varchar(50),
        load_datetime    datetime,
        is_valid         bit
    );




DROP TABLE IF EXISTS silver.ug_student_term;

CREATE TABLE silver.ug_student_term
    (
        started_year     varchar(20),
        term_name        varchar(100), 

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
