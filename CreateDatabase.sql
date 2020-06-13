IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'MyDB')
		DROP	DATABASE [MyDB]
GO
CREATE DATABASE [MYDB] ON  PRIMARY 
( NAME = N'MYDB', FILENAME = N'C:\MSSQL2012\Data\MYDB_Data.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10% )
 LOG ON 
( NAME = N'MYDB_log', FILENAME = N'C:\MSSQL2012\Logs\MYDB_Log.ldf' , SIZE = 1024KB , MAXSIZE = UNLIMITED , FILEGROWTH = 10%)
GO
ALTER DATABASE [MYDB]
SET RECOVERY SIMPLE WITH NO_WAIT
GO

CREATE DATABASE [MYDB] ON  PRIMARY 
( NAME = N'MYDB', FILENAME = N'E:\Data\MYDB_Data.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10% )
 LOG ON 
( NAME = N'MYDB_log', FILENAME = N'F:\Logs\MYDB_Log.ldf' , SIZE = 1024KB , MAXSIZE = UNLIMITED , FILEGROWTH = 10%)
GO
ALTER DATABASE [MYDB]
SET RECOVERY SIMPLE WITH NO_WAIT
GO
USE		[master]
GO
CREATE DATABASE [DatabaseName] ON  PRIMARY 
( NAME = N'DatabaseName_dat', FILENAME = N'D:\MSSQL\Data\DatabaseName_dat.mdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10240KB ),
 FILEGROUP [INDEX] 
( NAME = N'DatabaseName_idx', FILENAME = N'D:\MSSQL\Indx\DatabaseName_idx.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10240KB )
 LOG ON 
( NAME = N'DatabaseName_log', FILENAME = N'D:\MSSQL\Logs\DatabaseName_log.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10240KB )
GO

CREATE DATABASE [DatabaseName] ON  PRIMARY 
( NAME = N'DatabaseName_dat', FILENAME = N'D:\MSSQL\Data\DatabaseName_dat.mdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10240KB ),
 FILEGROUP [INDEX] 
( NAME = N'DatabaseName_idx', FILENAME = N'D:\MSSQL\Indx\DatabaseName_idx.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10240KB )
 LOG ON 
( NAME = N'DatabaseName_log', FILENAME = N'D:\MSSQL\Logs\DatabaseName_log.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10240KB )
GO

---------------------------------------------------------
-- Attach/Detach DBs
---------------------------------------------------------
CREATE DATABASE [MYDB] ON
( FILENAME = N'C:\Users\antho\OneDrive\Documents\SQLManager\Data\MYDB_Data.mdf' ),
( FILENAME = N'C:\Users\antho\OneDrive\Documents\SQLManager\Logs\MYDB_Log.ldf' )
FOR ATTACH
GO
ALTER DATABASE MYDB
SET RECOVERY SIMPLE WITH NO_WAIT
GO

USE master
GO
EXEC sp_detach_db 'DatabaseName', 'True'
GO
EXEC sp_attach_db 'DatabaseName','D:\MSSQL\Data\DatabaseName_dat.mdf',
					'D:\MSSQL\Indx\DatabaseName_idx.ndf', 
					'D:\MSSQL\Logs\DatabaseName_log.ldf'
GO
CREATE DATABASE DatabaseName
ON PRIMARY
(FILENAME =       'D:\MSSQL\Data\DatabaseName_dat.mdf'),
(FILENAME =       'D:\MSSQL\Indx\DatabaseName_idx.ndf'),
(FILENAME =       'D:\MSSQL\Logs\DatabaseName_log.ldf')
FOR ATTACH
GO

-----------------------------------------------------------------------------------------------------------------------------
USE		master
GO
EXEC		master.dbo.sp_detach_db @dbname = N'AdventureWorks',
						@keepfulltextindexfile = N'true'
EXEC sp_detach_db [MyDB2]
GO
EXEC sp_attach_db 'MyDB2','c:\data\MyDB2_Prm.mdf',
'c:\data\MyDB2_FG1_1.ndf', 
'c:\data\MyDB2_FG1_2.ndf', 
'c:\data\MyDB2.ldf'
GO

CREATE DATABASE MyDB2
ON PRIMARY
(FILENAME =       'c:\data\MyDB2_Prm.mdf'),
(FILENAME =       'c:\data\MyDB2_FG1_1.ndf'),
(FILENAME =       'c:\data\MyDB2_FG1_2.ndf'),
(FILENAME =       'c:\data\MyDB2.ldf')
FOR ATTACH
GO

CREATE DATABASE [AdventureWorks2012] ON
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER12\MSSQL\DATA\AdventureWorks2012_Data.mdf' ) FOR ATTACH_REBUILD_LOG;
GO
CREATE DATABASE [AdventureWorksDW2012] ON
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER12\MSSQL\DATA\AdventureWorksDW2012_Data.mdf' ) FOR ATTACH_REBUILD_LOG;
GO
CREATE DATABASE [DataIntegrationEngine] ON  PRIMARY 
( NAME = N'DataIntegrationEngine', FILENAME = N'C:\MSSQL2005\Data\DataIntegrationEngine.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10% )
 LOG ON 
( NAME = N'DataIntegrationEngine_log', FILENAME = N'C:\MSSQL2005\Logs\DataIntegrationEngine_log.ldf' , SIZE = 1024KB , MAXSIZE = UNLIMITED , FILEGROWTH = 10%)
GO

