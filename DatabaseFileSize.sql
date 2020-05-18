USE  master
GO
DBCC SQLPERF(logspace)
--Database Name   Log Size (MB) Log Space Used (%) Status
--DataIntegrationEngine 505.0547    1.924297 0
GO
USE  DataIntegrationEngine
GO
EXEC sp_spaceused
--database_name   database_size unallocated space
--DataIntegrationEngine 14816.13 MB  0.95 MB
--reserved   data   index_size  unused
--14653552 KB   11220224 KB  3387184 KB  46144 KB
USE DataIntegrationEngine
GO
SELECT DB_NAME() AS DbName, 
name AS FileName, 
size/128.0 AS CurrentSizeMB,
(size/128.0)/1024  AS CurrentSizeGB,
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB
FROM sys.database_files;
--
--
--DbName     FileName     CurrentSizeMB FreeSpaceMB
--DataIntegrationEngine  DataIntegrationEngine  14311.062500 0.625000
--DataIntegrationEngine  DataIntegrationEngine_log 505.062500  495.078125
USE master
--https://blog.sqlauthority.com/2010/02/08/sql-server-find-the-size-of-database-file-find-the-size-of-log-file/
SELECT DB_NAME(database_id) AS DatabaseName,
Name AS Logical_Name,
Physical_Name, 
(size*8)/1024 SizeMB,
((size*8)/1024.0)/1024 SizeGB
FROM sys.master_files
WHERE DB_NAME(database_id) = 'DataIntegrationEngine'
GO
--DatabaseName   Logical_Name    Physical_Name       SizeMB
--DataIntegrationEngine DataIntegrationEngine  E:\Data\DataIntegrationEngine_Data.MDF 14311
--DataIntegrationEngine DataIntegrationEngine_log F:\Logs\DataIntegrationEngine_Log.LDF 505

------------------------------

ALTER DATABASE ODS_WB_BANKING
SET RECOVERY SIMPLE WITH NO_WAIT
GO
--
----------------------------------
-- Switch to simple recovery mode
----------------------------------
USE		master
GO
DECLARE @MyDB AS VARCHAR(40),
@MySQL AS VARCHAR(150)
--
DECLARE DBList CURSOR FAST_FORWARD FOR
SELECT		name
FROM		sys.databases
WHERE		recovery_model_desc = 'FULL'
AND			owner_sid != 0x01
AND			name NOT LIKE 'MicroStrategy%'
ORDER BY	name
--
OPEN DBList;
FETCH NEXT FROM DBList INTO @MyDB
WHILE (@@FETCH_STATUS = 0)
BEGIN
	
	SET @MySQL = 'ALTER DATABASE ' + @MyDB + '
SET RECOVERY SIMPLE WITH NO_WAIT'
	
	EXEC(@MySQL)
	PRINT 'DBName: ' + @MyDB
	PRINT @MySQL
	PRINT '------------------------------'
	FETCH NEXT FROM DBList INTO @MyDB
END
CLOSE DBList
DEALLOCATE DBList


-------------------------------
-- Shrink Transaction Logs
-------------------------------
USE		master
GO
DECLARE @MyDB AS VARCHAR(40),
@MyLogName AS VARCHAR(40),
@MySQL AS VARCHAR(150)
--
DECLARE DBList CURSOR FAST_FORWARD FOR
SELECT		name
FROM		sys.databases
WHERE		owner_sid != 0x01
AND			name NOT LIKE 'Micro%'
AND			name NOT LIKE 'RedFrog%'
ORDER BY	name
--
OPEN DBList;
FETCH NEXT FROM DBList INTO @MyDB
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @MyLogName = (SELECT name FROM sys.master_files  WHERE database_id = DB_ID(@MyDB) AND file_id = 2)
	SET @MySQL = 'USE ' + @MyDB + '
DBCC SHRINKFILE(' + @MyLogName + ', 1)'
	PRINT @MySQL
	EXEC(@MySQL)
	--PRINT 'DBName: ' + @MyDB + ' - DBLog LogicalName: ' + @MyLogName
	FETCH NEXT FROM DBList INTO @MyDB
END
CLOSE DBList
DEALLOCATE DBList





--For SQL 2008 and Up.
ALTER DATABASE <DatabaseName> 
SET RECOVERY SIMPLE WITH NO_WAIT
GO
USE CRM_UCID_Staging
GO
DBCC SHRINKFILE(IntelligentDW_log, 1)
GO
DBCC SHRINKDATABASE(<DatabaseName>, TRUNCATEONLY)
GO

SELECT	(SELECT physical_name AS CurrentLocation FROM sys.master_files WHERE database_id = DB_ID(N'CRM_UCID_Staging') 
		AND file_id = 1), 
		(SELECT physical_name AS CurrentLocation FROM sys.master_files WHERE database_id = DB_ID(N'CRM_UCID_Staging') 
		AND file_id = 2),
		(SELECT name AS DBlogicalname FROM sys.master_files WHERE database_id = DB_ID(N'CRM_UCID_Staging') 
		AND file_id = 1), 
		(SELECT name AS LOGlogicalname FROM sys.master_files WHERE database_id = DB_ID(N'CRM_UCID_Staging') 
		AND file_id = 2)
--
