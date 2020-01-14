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
