http://www.datadisk.co.uk/html_docs/oracle/tuning_tools.htm


https://docs.oracle.com/cd/E11882_01/server.112/e41573/perf_overview.htm#PFGRF02503


https://stackoverflow.com/questions/11407349/mysql-how-to-export-and-import-an-sql-file-from-command-line


https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server


https://docs.microsoft.com/en-us/sql/relational-databases/import-export/bulk-import-and-export-of-data-sql-server


https://dev.mysql.com/doc/workbench/en/wb-performance-explain.html

https://dev.mysql.com/doc/refman/5.5/en/create-index.html
----------------------------------------------------------------------------------------------------------------------------
set profiling=1;
call  proc ( ');
show profiles; 
----------------------------------------------------------------------------------------------------------------------------
select r.end_date =  DATE_FORMAT(now(), '%Y-%m-%d %H:%i') 

select s.db_date, r.* from  schedules u join receivers r on u.id = r.sid
join system_calendars s on s.week_day in (case when r.mon = 1 then 0 else 7 end, 
								  case when r.tue = 1 then 1 else 7 end, 
								  case when r.wed = 1 then 2 else 7 end, 
								  case when r.thu = 1 then 3 else 7 end, 
								  case when r.fri = 1 then 4 else 7 end, 
								  case when r.sat = 1 then 5 else 7 end, 
								  case when r.sun = 1 then 6 else 7 end) 
where r.rid = 10 
and db_date > date_sub(r.start_date, interval 1 day)
order by db_date, sid

https://stackoverflow.com/questions/3333665/rank-function-in-mysql

http://www.folkstalk.com/2013/03/grouped-rank-function-mysql-sql-query.html
----------------------------------------------------------------------------------------------------------------------------
replication : async sync 

select * from 
table a
LEFT JOIN 
(
   SELECT MIN(id) as RowId, obj_id , obj_type, user_id from table
   GROUP BY  2, 3,4
) as b ON a.id = b.RowId
WHERE
   b.RowId IS not NULL
---------------------------------------------------------------------------------------------------------------------------- 
Linked server

recursive cte : top level user where manager id is null

# and @ table diff

non-clust index  primary key possible ?

non-clus and clus index diff ?

scope session 

@@identity, scope_identity 

ms sql explain plan 

system db ?

constriant and trigger ?

https://www.red-gate.com/simple-talk/sql/performance/which-of-your-stored-procedures-are-using-the-most-resources/

----------------------------------------------------------------------------------------------------------------------------
select 
source_code,
stats.total_elapsed_time/1000000 as seconds,
last_execution_time from sys.dm_exec_query_stats as stats
inner join(SELECT 
          text as source_code 
        FROM sys.dm_exec_sql_text(sql_handle)) AS query_text
order by total_elapsed_time desc 
limit 10  

select
source_code,
stats.total_elapsed_time/1000000 as seconds,
last_execution_time from sys.dm_exec_query_stats as stats
inner join(SELECT 
          text as source_code 
        FROM sys.dm_exec_sql_text(sql_handle)) AS query_text
order by total_physical_reads desc
limit 10 

----------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT TOP 10
 t.TEXT QueryName,
 s.execution_count AS ExecutionCount,
 s.max_elapsed_time AS MaxElapsedTime,
 ISNULL(s.total_elapsed_time / s.execution_count, 0) AS AvgElapsedTime,
 s.creation_time AS LogCreatedOn,
 ISNULL(s.execution_count / DATEDIFF(s, s.creation_time, GETDATE()), 0) AS FrequencyPerSec
 FROM sys.dm_exec_query_stats s
 CROSS APPLY sys.dm_exec_sql_text( s.sql_handle ) t
 ORDER BY
 s.max_elapsed_time DESC
 GO 
-----------------------------------------------------------------------------------------------------------------------------
 SELECT CASE WHEN database_id = 32767 then 'Resource' ELSE DB_NAME(database_id)END AS DBName
      ,OBJECT_SCHEMA_NAME(object_id,database_id) AS [SCHEMA_NAME]  
      ,OBJECT_NAME(object_id,database_id)AS [OBJECT_NAME]  
      ,*  FROM sys.dm_exec_procedure_stats  

SELECT CASE WHEN database_id = 32767 then 'Resource' ELSE DB_NAME(database_id)END AS DBName
      ,OBJECT_SCHEMA_NAME(object_id,database_id) AS [SCHEMA_NAME]  
      ,OBJECT_NAME(object_id,database_id)AS [OBJECT_NAME]
      ,cached_time
      ,last_execution_time
      ,execution_count
      ,total_worker_time / execution_count AS AVG_CPU
      ,total_elapsed_time / execution_count AS AVG_ELAPSED
      ,total_logical_reads / execution_count AS AVG_LOGICAL_READS
      ,total_logical_writes / execution_count AS AVG_LOGICAL_WRITES
      ,total_physical_reads  / execution_count AS AVG_PHYSICAL_READS
FROM sys.dm_exec_procedure_stats  
ORDER BY AVG_LOGICAL_READS DESC
------------------------------------------------------------------------------------------------------------------------------

SELECT
	TOP 5 qs.total_worker_time /(qs.execution_count*60000000) AS [Avg CPU TIME IN mins],
	qs.execution_count,
	qs.min_worker_time / 60000000 AS [Min CPU TIME IN mins],
	qs.total_worker_time/qs.execution_count, SUBSTRING(qt.text,qs.statement_start_offset/2, 
	(case when qs.statement_end_offset = -1 then len(convert(nvarchar(max), qt.text)) * 2 else qs.statement_end_offset end
	 -qs.statement_start_offset)/2) as query_text, dbname=db_name(qt.dbid), object_name(qt.objectid) as [Object name] 
	 
	 select * FROM sys.dm_exec_query_stats qs cross apply sys.dm_exec_sql_text(qs.sql_handle) as qt ORDER BY [Avg CPU Time in mins]

--------------------------------------------------------------------------------------------------------------------------------	 	 
SELECT CASE WHEN dbid = 32767 then 'Resource' ELSE DB_NAME(dbid)END AS DBName
      ,OBJECT_SCHEMA_NAME(objectid,dbid) AS [SCHEMA_NAME]  
      ,OBJECT_NAME(objectid,dbid)AS [OBJECT_NAME]
      ,MAX(qs.creation_time) AS 'cache_time'
      ,MAX(last_execution_time) AS 'last_execution_time'
      ,MAX(usecounts) AS [execution_count]
      ,SUM(total_worker_time) / SUM(usecounts) AS AVG_CPU
      ,SUM(total_elapsed_time) / SUM(usecounts) AS AVG_ELAPSED
      ,SUM(total_logical_reads) / SUM(usecounts) AS AVG_LOGICAL_READS
      ,SUM(total_logical_writes) / SUM(usecounts) AS AVG_LOGICAL_WRITES
      ,SUM(total_physical_reads) / SUM(usecounts)AS AVG_PHYSICAL_READS        
FROM sys.dm_exec_query_stats qs  
   join sys.dm_exec_cached_plans cp on qs.plan_handle = cp.plan_handle 
   CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) 
WHERE objtype = 'Proc' 
  AND text
       NOT LIKE '%CREATE FUNC%' 
       GROUP BY cp.plan_handle,DBID,objectid 
--------------------------------------------------------------------------------------------------------------------------------	 	   
SELECT secret_id, 
@currank := IF(@prevRank = (TIMESTAMPDIFF(SECOND, first_share,last_share)), @curRank, @incRank) AS rank, ShareCount,
@incRank := @incRank + 1, 
@prevRank := TIMESTAMPDIFF(SECOND, first_share,last_share) as timediff
FROM   (SELECT secret_id, min(added_on) as first_share, max(added_on) as last_share,
               Count(DISTINCT user_id)  AS ShareCount            
        FROM   secret_shares                
        GROUP  BY 1 
        ORDER  BY sharecount desc , secret_id DESC 
        LIMIT  10) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r 
--------------------------------------------------------------------------------------------------------------------------------	 
SELECT id_student, id_class, grade,
   @student:=CASE WHEN @class <> id_class THEN 0 ELSE @student+1 END AS rn,
   @class:=id_class AS clset
FROM
  (SELECT @student:= -1) s,
  (SELECT @class:= -1) c,
  (SELECT *
   FROM mytable
   ORDER BY id_class, id_student
  ) t

--------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM (
  SELECT s.*, @rank := @rank + 1 rank FROM (
    SELECT user_id, sum(points) TotalPoints FROM t
    GROUP BY user_id
  ) s, (SELECT @rank := 0) init
  ORDER BY TotalPoints DESC
) r
WHERE user_id = 3

--------------------------------------------------------------------------------------------------------------------------------
VARCHAR is variable-length.

CHAR is fixed length.

VARCHAR is reserved by Oracle to support distinction between NULL and empty string in future, as ANSI standard prescribes. 

VARCHAR2 does not distinguish between a NULL and empty string, and never will. If you rely on empty string and NULL being the same thing, you should use VARCHAR2 .

VARCHAR is generally used for sql where as VARCHAR2 is used for the Mysql

VARCHAR2 is Oracle and VARCHAR is ansi standard

varchar is of fixed size where as varchar2 is of variable where varhcar ranges from 1 to 2000 characters and varchar2 ranges from 1 to 4000 characters.


SELECT TOP 1 salary
FROM (
      SELECT DISTINCT TOP n salary
      FROM employee
      ORDER BY salary DESC
      ) a
ORDER BY salary
SELECT Salary,EmpName
FROM
  (
   SELECT Salary,EmpName,ROW_NUMBER() OVER(ORDER BY Salary) As RowNum
   FROM EMPLOYEE
   ) As A
WHERE A.RowNum IN (2,3)
Sub Query :

SELECT *
FROM Employee Emp1
WHERE (N-1) = (
               SELECT COUNT(DISTINCT(Emp2.Salary))
               FROM Employee Emp2
               WHERE Emp2.Salary > Emp1.Salary
               )
--------------------------------------------------------------------------------------------------------------------------------
GO
WITH Emp_CTE AS (
SELECT EmployeeID, ContactID, LoginID, ManagerID, Title, BirthDate
FROM HumanResources.Employee
WHERE ManagerID IS NULL
UNION ALL
SELECT e.EmployeeID, e.ContactID, e.LoginID, e.ManagerID, e.Title, e.BirthDate
FROM HumanResources.Employee e
INNER JOIN Emp_CTE ecte ON ecte.EmployeeID = e.ManagerID
)
SELECT *
FROM Emp_CTE
GO


--------------------------------------------------------------------------------------------------------------------------------
select lastname , dept_no, salary,
         sum(salary) over (order by dept_no, lastname) running_total
        ,sum(salary) over (partition by dept_no order by lastname) dept_total
    from employee
    order by dept_no, lastname;


LASTNAME                DEPT_NO     SALARY RUNNING_TOTAL DEPT_TOTAL
-------------------- ---------- ---------- ------------- ----------
Jane                          2        500           500        500
Tom                           2        200           700        700
Jack                          3        300          1000        300
Jason                         3        400          1400        700


drop table employee;

--------------------------------------------------------------------------------------------------------------------------------

DELETE e1 FROM  e1,  e2 
          WHERE e1.id = e2.id  
         AND e1.ma = e2.ma 
         AND  e1.id > e2.id;

delete s from us_aman s
where s.id not in (select min(y.id) from us_aman y group by y.c1, y.c2 )

--------------------------------------------------------------------------------------------------------------------------------
Assuming cell A1 has the email id, the formula for getting user name is =LEFT(A1,FIND("@",A1)-1)


SELECT email, (SPLIT_STR(email, '@', 1)) AS domain FROM users where email is not null

DROP FUNCTION `SPLIT_STR`;
CREATE DEFINER=`sagoon_dev`@`localhost` FUNCTION `SPLIT_STR`(`x` VARCHAR(255), `delim` VARCHAR(12), `pos` INT) RETURNS VARCHAR(255) CHARSET latin1 NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '')

--------------------------------------------------------------------------------------------------------------------------------
SELECT SUBSTRING(email, 1, LOCATE('@', email) - 1) AS localpart FROM users where email is not null

select SPLIT_STR(email, '@', 1) from users  users where email is not null

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX("foo@bar.buz", '@', -1), '.', -1)   -- buz

SELECT SUBSTRING_INDEX("foo@bar.buz.com", '@', -1) --  bar.buz.com

SELECT SUBSTRING_INDEX("foo@bar.buz.com", '@', 1) -- foo

--------------------------------------------------------------------------------------------------------------------------------

SELECT
    CONCAT('DROP ',ROUTINE_TYPE,' `',ROUTINE_SCHEMA,'`.`',ROUTINE_NAME,'`;') as stmt
FROM information_schema.ROUTINES where ROUTINE_SCHEMA = 'dev_old';

-------------------------------------------------------------------------------------------------------------------------------- 
SHOW OPEN TABLES WHERE `Table` LIKE '%[TABLE_NAME]%' AND `Database` LIKE '[DBNAME]' AND In_use > 0;
show open tables WHERE In_use > 0

-------------------------------------------------------------------------------------------------------------------------------- 
 `created_on`  timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

SHOW TABLE STATUS

ROW_FORMAT=COMPRESSED or FIXED or DYNAMIC -- MyISAM  -- changed due to overflow reason in case of BLOB amd TEXT case 
ROW_FORMAT=COMPACT or REDUNDANT -- InnoDB 

ROW_FORMAT=DYNAMIC and ROW_FORMAT=COMPRESSED are variations of ROW_FORMAT=COMPACT 

-------------------------------------------------------------------------------------------------------------------------------- 

select a.TABLE_NAME, a.column_Count, b.TABLE_NAME, b.column_Count
  from dev.COLUMNS_QA b left join 
(
SELECT TABLE_NAME, COUNT(COLUMN_NAME) as column_Count 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_CATALOG = 'def' 
    AND TABLE_SCHEMA = 'xyz' 
 group by TABLE_NAME) a on a.TABLE_NAME = b.TABLE_NAME
 -- where b.TABLE_NAME is null
where a.column_Count <> b.column_Count

-------------------------------------------------------------------------------------------------------------------------------- 

Using DYNAMIC or COMPRESSED means that InnoDB stores varchar/text/blob fields that don't fit in the page completely off-page. But other than those columns, which then only count 20 bytes per column, the InnoDB row size limit has not changed; it's still limited to about 8000 bytes per row.

InnoDB only supports indexes of 767 bytes per column. You can raise this 3072 bytes by setting innodb_large_prefix=1 and using either DYNAMIC or COMPRESSED row format.

Using COMPRESSED row format does not make InnoDB support longer indexes

I've changed "innodb_file_format" from "Antelope" to "Barracuda" bcoz of following reasons.

To avoid row size limit
To avoid column index size limit
-------------------------------------------------------------------------------------------------------------------------------- 

CREATE PROCEDURE `sfgfasfgsd`() NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
BEGIN
     
     DEClARE usemig_cur CURSOR FOR SELECT * FROM mig;	          
	 SET v_id      = 0;
	 OPEN usemig_cur;
          update_mig: LOOP  
                             FETCH usemig_cur INTO mig_id;
							 
            -- Statement which need to update 

		  END LOOP update_mig;
     CLOSE usemig_cur;
     
END
-------------------------------------------------------------------------------------------------------------------------------- 
mysql> LOAD DATA LOCAL INFILE '/path/pet.txt' INTO TABLE pet;

-- Pet.txt :  Whistler        Gwen    bird    \N      1997-12-09      \N

mysql> LOAD DATA LOCAL INFILE '/path/pet.txt' INTO TABLE pet
    -> LINES TERMINATED BY '\r\n';

mysql> INSERT INTO pet
    -> VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);

-------------------------------------------------------------------------------------------------------------------------------- 

DELIMITER $$

CREATE PROCEDURE GetFruits(IN fruitArray VARCHAR(255))
BEGIN

  SET @sql = CONCAT('SELECT * FROM Fruits WHERE Name IN (', fruitArray, ')');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

END
$$

DELIMITER ;
How to use:

SET @fruitArray = '\'apple\',\'banana\'';
CALL GetFruits(@fruitArray);

-------------------------------------------------------------------------------------------------------------------------------- 
SHOW CREATE TABLE mysql.general_log;
SHOW CREATE TABLE mysql.slow_log;

truncate mysql.general_log;

SHOW VARIABLES LIKE "general_log%";

SET global general_log = 1;
SET global log_output = 'table';

SET GLOBAL general_log = 'ON';
SET GLOBAL slow_query_log = 'ON';


SET global log_output = 'FILE';
SET global general_log_file='/Applications/MAMP/logs/mysql_general.log';
SET global general_log = 1;
show processlist

SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST WHERE COMMAND != 'Sleep';

SET @old_log_state = @@global.general_log;

SET GLOBAL general_log = 'OFF';

ALTER TABLE mysql.general_log ENGINE = MyISAM;

SET GLOBAL general_log = @old_log_state;

SET GLOBAL general_log = 'ON';
-------------------------------------------------------------------------------------------------------------------------------- 

BEGIN TRANSACTION;  

BEGIN TRY  
    -- Generate a constraint violation error.  
    DELETE FROM Production.Product  
    WHERE ProductID = 980;  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  

    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;  
END CATCH;  

IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  
GO  

-------------------------------------------------------------------------------------------------------------------------------- 
BEGIN CATCH  
    -- Execute error retrieval routine.  
    EXECUTE usp_GetErrorInfo;  

    -- Test XACT_STATE:  
        -- If 1, the transaction is committable.  
        -- If -1, the transaction is uncommittable and should   
        --     be rolled back.  
        -- XACT_STATE = 0 means that there is no transaction and  
        --     a commit or rollback operation would generate an error.  

    -- Test whether the transaction is uncommittable.  
    IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT  
            N'The transaction is in an uncommittable state.' +  
            'Rolling back transaction.'  
        ROLLBACK TRANSACTION;  
    END;  

    -- Test whether the transaction is committable.  
    IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT  
            N'The transaction is committable.' +  
            'Committing transaction.'  
        COMMIT TRANSACTION;     
    END;  
END CATCH;  
GO  

-------------------------------------------------------------------------------------------------------------------------------- 
ALTER TABLE LastYearSales
ADD CONSTRAINT ckSalesTotal CHECK (SalesLastYear >= 0);
GO


USE AdventureWorks2012;
GO
 
IF OBJECT_ID('UpdateSales', 'P') IS NOT NULL
DROP PROCEDURE UpdateSales;
GO
 
CREATE PROCEDURE UpdateSales
  @SalesPersonID INT,
  @SalesAmt MONEY = 0
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;
      UPDATE LastYearSales
      SET SalesLastYear = SalesLastYear + @SalesAmt
      WHERE SalesPersonID = @SalesPersonID;
    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;

 EXECUTE usp_GetErrorInfo;  

 
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorLine INT = ERROR_LINE();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
 
    PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
    PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));
 
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH
END;

ERROR_NUMBER(): The number assigned to the error.
ERROR_LINE(): The line number inside the routine that caused the error.
ERROR_MESSAGE(): The error message text, which includes the values supplied for any substitutable parameters, such as times or object names.
ERROR_SEVERITY(): The error’s severity.
ERROR_STATE(): The error’s state number.
ERROR_PROCEDURE(): The name of the stored procedure or trigger that generated the error.

-------------------------------------------------------------------------------------------------------------------------------- 

-- Find the next occurrence
SET @pos = CHARINDEX(@substr, @str, @pos);


INSTR (str, pattern, [starting position, [nth occurrence]])

-- Find the second occurrence of letter 'o'
SELECT INSTR('Boston', 'o', 1, 2) FROM dual;
-- Result: 5
-------------------------------------------------------------------------------------------------------------------------------- 
USE AdventureWorks
GO
WITH Emp_CTE AS (
SELECT EmployeeID, ContactID, LoginID, ManagerID, Title, BirthDate
FROM HumanResources.Employee
WHERE ManagerID IS NULL
UNION ALL
SELECT e.EmployeeID, e.ContactID, e.LoginID, e.ManagerID, e.Title, e.BirthDate
FROM HumanResources.Employee e
INNER JOIN Emp_CTE ecte ON ecte.EmployeeID = e.ManagerID
)
SELECT *
FROM Emp_CTE
GO
---------------------------------------------------------------------------------------------
cat *.sql | mysql? Do you need them in any specific order?

If you have too many to handle this way, then try something like:

find . -name '*.sql' | awk '{ print "source",$0 }' | mysql --batch

for SQL in *.sql; do DB=${SQL/\.sql/}; echo importing $DB; mysql $DB < $SQL; done

find . -name '*.sql'|xargs mysql ...
#!/bin/bash

databases=$(ls *.sql)

for database in ${databases};do
    name=${database%.*}
    mysql -u root -ppassword -e "CREATE DATABASE IF NOT EXISTS ${name} DEFAULT CHARACTER SET utf8;"
    mysql -u root -ppassword ${name} < ${database}
done

---------------------------------------------------------------------------------------------

WITH OURCTE (EMPNO, ENAME, MGR, EMPLEVEL)
AS (SELECT EMPNO, ENAME, MGR, 1 EMPLEVEL --Initial Subquery
FROM Emp
WHERE MGR IS NULL
UNION ALL
SELECT E.EMPNO, E.ENAME, E.MGR, CTE.EMPLEVEL + 1 --Recursive Subquery
FROM EMP E
INNER JOIN OURCTE CTE ON E.MGR = CTE.EMPNO
WHERE E.MGR IS NOT NULL)

SELECT *
FROM OURCTE
ORDER BY EMPLEVEL;
---------------------------------------------------------------------------------------------
CREATE PROCEDURE GetEmployeesByCity.
@City NVARCHAR(15)
,@EmployeeIds VARCHAR(200) OUTPUT.
SET NOCOUNT ON;
SELECT @EmployeeIds = COALESCE(@EmployeeIds + ',', '') + CAST(EmployeeId AS VARCHAR(5))
FROM Employees.
WHERE City = @City.
---------------------------------------------------------------------------------------------
function IsMobileNumber(txtMobId) {
var mob = /^[1-9]{1}[0-9]{9}$/;
var txtMobile = document.getElementById(txtMobId);
if (mob.test(txtMobile.value) == false) {
    alert("Please enter valid mobile number.");
    txtMobile.focus();
    return false;
}
return true;

var val = number.value
if (/^\d{10}$/.test(val)) {
    // value is ok, use it
} else {
    alert("Invalid number; must be ten digits")
    number.focus()
    return false
}

if(number.value == "") {
    window.alert("Error: Cell number must not be null.");
    number.focus();
    return false;
}

if(number.length != 10) {
    window.alert("Phone number must be 10 digits.");
    number.focus();
    return false;
}

---------------------------------------------------------------------------------------------
"One of the things that has made it a little more challenging is that I’d like to have a platform 
where I could share my ideas and offer up ways to improve…(service, operations, technology, communication, etc…) "


Desire to take on more responsibility and grow in a career.
Desire to improve work/life balance.
This is the time to be ready and take responsibility to grow and learn and always wanted to work with Amazon.
-------------------------------------------------------------------------------------------------------------------------------- 
