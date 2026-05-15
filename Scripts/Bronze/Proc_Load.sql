/*
### 📄 Brief Documentation

**Purpose:**  
Stored procedure to load CSV data into Bronze tables.

**What it does:**

*   Truncates (clears) both tables
*   Bulk loads data from CSV files
*   Tracks and prints load duration
*   Handles errors using TRY/CATCH

**Warning ⚠️:**  
Running it **deletes all existing data** before loading new data.

**Why used:**  
To automate and monitor data loading into the Bronze layer.

Example Use:
EXEC bronze.load_sis_enr_data;

*/


CREATE or ALTER PROCEDURE bronze.load_sis_enr_data AS
BEGIN
	DECLARE @StartTime DATETIME, @EndTime DATETIME, @BatchStartTime DATETIME, @BatchEndTime DATETIME; 
	BEGIN TRY
		SET @BatchStartTime = GETDATE();
		PRINT '======================================================'
		PRINT 'Loading Data to Bronze Layer'
		PRINT '======================================================'

		PRINT '------------------------------------------------------'
		PRINT 'Loading sis_enr_cleaned data'
		PRINT '------------------------------------------------------'

		SET @StartTime = GETDATE();
		PRINT '>> Truncating bronze.sis_enr_cleaned'
		TRUNCATE TABLE bronze.sis_enr_cleaned;

		PRINT '>> Inserting data into bronze.sis_enr_cleaned...'
		BULK INSERT bronze.sis_enr_cleaned
		FROM 'C:\Users\ahmed\Desktop\Data Warhouse\DataSource\sis_enr_cleaned.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- SELECT * FROM bronze.sis_enr_cleaned;
		-- SELECT COUNT(*) FROM bronze.sis_enr_cleaned;
		SET @EndTime = GETDATE();
		PRINT '>> Data load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR(10)) + ' seconds.';

		PRINT '------------------------------------------------------'
		PRINT 'Loading sis_enr_cleaned data'
		PRINT '------------------------------------------------------'

		SET @StartTime = GETDATE();
		PRINT '>> Truncating bronze.sis_full_ug_enr'
		TRUNCATE TABLE bronze.sis_full_ug_enr;

		PRINT '>> Inserting data into bronze.sis_full_ug_enr...'
		BULK INSERT bronze.sis_full_ug_enr
		FROM 'C:\Users\ahmed\Desktop\Data Warhouse\DataSource\sis_full_ug_enr.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		
		-- SELECT * FROM bronze.sis_full_ug_enr;
		-- SELECT COUNT(*) FROM bronze.sis_full_ug_enr;
		SET @EndTime = GETDATE();
		PRINT '>> Data load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR(10)) + ' seconds.';
		PRINT '======================================================'
		SET @BatchEndTime = GETDATE();
		PRINT 'Batch Duration: ' + CAST(DATEDIFF(SECOND, @BatchStartTime, @BatchEndTime) AS NVARCHAR(10)) + ' seconds.';
	END TRY
	BEGIN CATCH
		PRINT 'Error occurred while loading data: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
		PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
	END CATCH
END
