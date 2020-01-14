USE		--[master]
GO
-------------------------------
--
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
