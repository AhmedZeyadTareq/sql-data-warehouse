/*
    📄 Brief Documentation
Purpose:
Recreates Bronze tables (sis_full_ug_enr) for loading student enrollment data.
What it does:
Drops tables if they exist
Creates them again with defined structure

Warning ⚠️:
Running this script deletes all existing data and recreates the tables from scratch.
Why used:
To ensure clean structure before loading fresh data.
Provide your feedback on BizChat
    */

    
IF OBJECT_ID('bronze.sis_full_ug_enr', 'U') IS NOT NULL
    DROP TABLE bronze.sis_full_ug_enr; 

CREATE TABLE bronze.sis_full_ug_enr (
    Term_Code INT,                         -- e.g., 2302
    Term NVARCHAR(100),                    -- e.g., 2022/2023 Spring-UGRD and ASP
    Career NVARCHAR(20),                   -- e.g., UGRD
    College NVARCHAR(100),                 -- e.g., Arts and Sciences
    Program NVARCHAR(100),                 -- e.g., Biology
    Id NVARCHAR(20),                       -- e.g., 01220106 (kept as string to preserve leading zero)
    Name NVARCHAR(200),                    -- e.g., Aya Abbas Hadi Salih
    Subject NVARCHAR(20),                  -- e.g., ASP
    Unit_Taken DECIMAL(5,2),               -- e.g., 0.00
    Gender CHAR(1),                         -- e.g., F
    Mapped_Id NVARCHAR(20),
    Validation_Key NVARCHAR(10),
)
