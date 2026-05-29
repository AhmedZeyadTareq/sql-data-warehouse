/*
### 📄 Brief Documentation

Purpose:
Stored procedure to clean and load enrollment data from Bronze to Silver layer.

What it does:
- Truncates and reloads the tables

Tables:

1. bronze.load_sis_enr_data
	load the data as it is from the source.

Warning:
Truncates tables → deletes all data (full refresh)

Example:
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
		PRINT 'Loading sis enrollment full UG data'
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
