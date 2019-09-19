--DROP ALL TABLES
DECLARE @MyTable AS VARCHAR(50),
@MyProc AS VARCHAR(50),
@MySFunc AS VARCHAR(50),
@MyTFunc AS VARCHAR(50),
@MySQL AS VARCHAR(150)
--
DECLARE TableName CURSOR FAST_FORWARD FOR
SELECT name
FROM sysobjects (NOLOCK)
WHERE xtype = 'U'
ORDER BY[name]
--
OPEN TableName;
FETCH NEXT FROM TableName INTO @MyTable
WHILE (@@FETCH_STATUS = 0)
BEGIN
SET @MySQL = 'DROP TABLE [' + @MyTable + ']'
PRINT @MySQL
EXEC(@MySQL)
PRINT '...........Executed'
FETCH NEXT FROM TableName INTO @MyTable
END
CLOSE TableName
DEALLOCATE TableName
-------------------------------------------------------
--DROP ALL PROCEDURES
DECLARE ProcName CURSOR FAST_FORWARD FOR
SELECT name
FROM sysobjects (NOLOCK)
WHERE xtype = 'P'
ORDER BY[name]
--
OPEN ProcName;
FETCH NEXT FROM ProcName INTO @MyProc
WHILE (@@FETCH_STATUS = 0)
BEGIN
SET @MySQL = 'DROP PROC [' + @MyProc + ']'
PRINT @MySQL
EXEC(@MySQL)
PRINT '...........Executed'
FETCH NEXT FROM ProcName INTO @MyProc
END
CLOSE ProcName
DEALLOCATE ProcName
-------------------------------------------------------
--DROP ALL FUNCTIONS
DECLARE SFuncName CURSOR FAST_FORWARD FOR
SELECT name
FROM sysobjects (NOLOCK)
WHERE xtype = 'FN'
ORDER BY[name]
--
OPEN SFuncName;
FETCH NEXT FROM SFuncName INTO @MySFunc
WHILE (@@FETCH_STATUS = 0)
BEGIN
SET @MySQL = 'DROP FUNCTION [' + @MySFunc + ']'
PRINT @MySQL
EXEC(@MySQL)
PRINT '...........Executed'
FETCH NEXT FROM SFuncName INTO @MySFunc
END
CLOSE SFuncName
DEALLOCATE SFuncName
-------------------------------------------------------
--DROP ALL FUNCTIONS
DECLARE TFuncName CURSOR FAST_FORWARD FOR
SELECT name
FROM sysobjects (NOLOCK)
WHERE xtype = 'TF'
ORDER BY[name]
--
OPEN TFuncName;
FETCH NEXT FROM TFuncName INTO @MyTFunc
WHILE (@@FETCH_STATUS = 0)
BEGIN
SET @MySQL = 'DROP FUNCTION [' + @MyTFunc + ']'
PRINT @MySQL
EXEC(@MySQL)
PRINT '...........Executed'
FETCH NEXT FROM TFuncName INTO @MyTFunc
END
CLOSE TFuncName
DEALLOCATE TFuncName
/*
C = Check constraint
D = Default (constraint or stand-alone)
P = SQL stored procedure
FN = SQL scalar function
R = Rule 
RF = Replication filter procedure
TR = SQL trigger (schema-scoped DML trigger, or DDL trigger at either the database or server scope)
IF = SQL inline table-valued function
TF = SQL table-valued function
V = View
*/