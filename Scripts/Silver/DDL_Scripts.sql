/*
### 📄 Brief Documentation

**Purpose:**  
Create Silver layer tables for cleaned and aggregated enrollment data.

**What it does:**

*   Drops existing tables if they exist
*   Creates `silver.ug_enrollment_clean` for cleaned detailed data
*   Creates `silver.ug_student_term` for aggregated student-level data

**Tables:**

1. **silver.ug_enrollment_clean**
   *   Stores cleaned, row-level enrollment data
   *   One row per student per subject
   *   Includes:
       - student info (ID, name, gender)
       - academic info (term, program, college)
       - subject and units_taken (raw string)
       - data quality flag (`is_valid`)
       - load tracking (`source_file`, `load_datetime`)

2. **silver.ug_student_term**
   *   Stores aggregated data per student per term
   *   One row per student per term
   *   Includes:
       - student info (ID, name, gender)
       - academic info (term, program, college)
       - total_courses (count of subjects)
       - total_units (numeric sum)
       - FTE status (`is_fte`)
       - load tracking (`source_file`, `load_datetime`)

**Warning ⚠️:**  
Running this script **drops existing tables**, which permanently removes all stored data and structure before recreating them.

**Why used:**  
To define structured tables in the Silver layer for cleaned and aggregated analytics data.
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
