--BACKUP DATABASE
BACKUP DATABASE DatabaseName TO DISK='E:\Backup\DatabaseName_YYYYMMDD.bak'  WITH COMPRESSION, FORMAT, INIT, COPY_ONLY, NAME = N'DatabaseName_YYYYMMDD'
----------------------------------------------
--RESTORE DATABASE
--REGULAR RESTORE
--Step 1: Retrieve the Logical file name of the database from backup.
RESTORE FILELISTONLY FROM DISK = 'X:\Folder\DatabaseName_YYYYMMDD.BAK'
GO
--Step 2: Use the values in the LogicalName Column in following Step.
--Make Database to single user Mode
ALTER DATABASE <DatabaseName>
SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--Restore Database
RESTORE DATABASE <DatabaseName> FROM DISK = 'X:\Folder\DatabaseName _YYYYMMDD.BAK' WITH REPLACE,
MOVE 'DatabaseName_Data' TO 'X:\Folder\DatabaseName_Data.MDF', 
MOVE 'DatabaseName_Log' TO 'X:\Folder\DatabaseName_Log.LDF'
/*If there is no error in statement before database will be in multiusermode.If error occurs please execute following command it will convertdatabase in multi user.*/
ALTER DATABASE <DatabaseName> 
SET MULTI_USER
GO

--------------------------------------------------------
--https://www.mssqltips.com/sqlservertip/4935/optimize-sql-server-database-restore-performance
--https://social.msdn.microsoft.com/Forums/sqlserver/en-US/a17cac4b-cf5d-4d90-9498-8335d21129d2/sql-server-maxtransfersize?forum=sqlkjmanageability
--https://www.sqlservercentral.com/blogs/optimizing-sql-server-backup-and-restore

DBCC TRACEON(3213,-1)
DBCC TRACEON(3605,-1)

RESTORE DATABASE DatabaseName FROM DISK= N'F:\DataLoadingStaging\DatabaseName\iWBDatabaseFullBackup_AftOvn_20200104.bak'  
WITH REPLACE,   FILE=1, NOUNLOAD, STATS=5,
MOVE N'pdenvcu_Data' TO N'F:\Data\DatabaseName_Data.mdf' ,  
MOVE N'pdenvcu_Log' TO N'G:\Logs\DatabaseName_Log.ldf'

DECLARE		@dtfromdate DATETIME= DATEADD(HOUR,-1,GETDATE()),
					@dtTodate DATETIME = GETDATE()
EXEC xp_ReadErrorLog 0, 1, NULL, NULL, @dtfromdate, @dtTodate


RESTORE DATABASE DatabaseName FROM DISK= N'F:\DataLoadingStaging\DatabaseName\iWBDatabaseFullBackup_AftOvn_20200104.bak'  
WITH REPLACE,   FILE=1, NOUNLOAD, STATS=5, MAXTRANSFERSIZE = 4194302, BUFFERCOUNT = 26,
MOVE N'pdenvcu_Data' TO N'F:\Data\DatabaseName_Data.mdf' ,  
MOVE N'pdenvcu_Log' TO N'G:\Logs\DatabaseName_Log.ldf'


--------------------------------------------------------
--RESTORE FULL DATABASE ON STANDBY
RESTORE DATABASE DatabaseName FROM DISK= N'H:\DataLoadingStaging\DatabaseName\iWBDatabaseFullBackup_AftOvn_20160416.bak' 
WITH FILE = 1,  
MOVE N'DatabaseNameData' TO N'H:\Data\DatabaseName_Data.mdf' , 
MOVE N'DatabaseNameLog' TO N'L:\Logs\DatabaseName_Log.ldf', 
REPLACE, STANDBY = N'H:\Data\DatabaseName_STANDBY_20160416.bak', NOUNLOAD, STATS = 10

--RESTORE DIFFERENTIAL DATABASE ON STANDBY
RESTORE DATABASE DatabaseName FROM DISK= N'H:\DataLoadingStaging\DatabaseName\iWBDatabaseDifferentialBackup_EOD_20130101.bak' 
WITH FILE = 1, 
MOVE N'DatabaseNameData' TO N'H:\Data\DatabaseName_Data.mdf' , 
MOVE N'DatabaseNameLog' TO N'L:\Logs\DatabaseName_Log.ldf',
REPLACE, STANDBY = N'H:\Data\DatabaseName_STANDBY_20130101.bak', NOUNLOAD, STATS = 10

--RESTORE LOG ON STANDBY
RESTORE LOG DatabaseName FROM DISK= N'H:\DataLoadingStaging\DatabaseName\iWBLogBackup_INCR_20130101.bak' 
WITH FILE = 1, 
REPLACE, STANDBY = N'H:\Data\DatabaseName_STANDBY_INCR_20130101.bak', NOUNLOAD, STATS = 10

--
RESTORE DATABASE DatabaseName WITH RECOVERY, CONTINUE_AFTER_ERROR
