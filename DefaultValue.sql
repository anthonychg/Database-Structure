--https://blog.sqlauthority.com/2020/06/27/sql-server-adding-default-value-to-existing-table/
CREATE TABLE myTable (ID INT)
GO
INSERT INTO myTable (ID)
VALUES (1), (2), (3)
GO
SELECT *
FROM myTable
GO

--Method 1: Add Column with Default for Future Inserts
ALTER TABLE myTable
ADD newCol VARCHAR(10) DEFAULT 'DefValue'
GO
INSERT INTO myTable (ID)
VALUES (4)
GO

-- Method 2: Add Column with Default Value for All Inserts
ALTER TABLE myTable
ADD newColWithVal VARCHAR(10) DEFAULT 'DefValue'
WITH VALUES
GO
