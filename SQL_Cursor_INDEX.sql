SELECT
    a.name AS Index_Name,
    OBJECT_NAME(a.object_id),
    COL_NAME(b.object_id,b.column_id) AS Column_Name,
    b.index_column_id,
    b.key_ordinal,
    b.is_included_column  
FROM
    sys.indexes AS a  
INNER JOIN
    sys.index_columns AS b   
       ON a.object_id = b.object_id AND a.index_id = b.index_id  
WHERE
        a.is_hypothetical = 0 AND
    a.object_id = OBJECT_ID('table_name');


Implicit cursor will select and return only (only) one row
like :
select ename, job into v_ename, v_job
from emp
where empno = 7839;
Explicit cursor can have one row or multiple
like in previous example its explicit because statement may return more then one row.
another example for explict cursor:
declare
cursor c1 is select ename, job, sal from emp;
v_ename emp.ename%type;
v_job emp.job%type;
v_sal emp.sal%type;
begin
open c1;
loop
fetch c1 into v_ename, v_job, v_sal;
exit when c1%notfound;
dbms_output.put_line(v_ename||'  '|v_job||'  '||v_sal);
end loop;
end;
/Implicit cursors are created and closed by the PL/SQL engine itself. Implicit cursors are given the name SQL. However explicit cursors are user defined.

SQL%ISOPEN is always false as the prompt is returned only when done
SQL%FOUND
SQL%NOTFOUND
SQL%ROWCOUNT all hold gud.

?CREATE OR REPLACE FUNCTION f RETURN SYS_REFCURSOR
AS
  c SYS_REFCURSOR;
BEGIN
  OPEN c FOR select * from dual;
  RETURN c;
END; 
/

Call the above function and fetch all rows from the cursor it returns:
set serveroutput on
DECLARE
 c SYS_REFCURSOR;
 v VARCHAR2(1);
BEGIN
 c := f();   -- Get ref cursor from function
 LOOP 
   FETCH c into v;
   EXIT WHEN c%NOTFOUND;
   dbms_output.put_line('Value from cursor: '||v);
 END LOOP;
END;
/

The ref cursor is a "pointer" data types that allows you to quickly reference any cursor result (usually an internal PL/SQL table array) with data values kept in super-fast RAM.


A REF Cursor is a datatype that holds a cursor value . A REF Cursor can be opened on the server and passed ?OPEN FOR , ?to the client as a unit rather than fetching one row at a time? ?

A Normal Cursor is a simple cursor which act as a static one where as Ref Cursor is a Dynamic Cursor which acts dynamically

 SYS_REFCURSOR is predefined REF CURSOR defined in standard package of Oracle located at following location in windows: %ORACLE_HOME%/rdbms/admin/stdspec.sql
where %ORACLE_HOME% = C:\oraclexe_32bit\app\oracle\product\11.2.0\server\

ef Cursor:
ref cursor is a data structure which points to an object which in turn points to the memory location.
ex:
create or replace procedure test()
as
begin
type ref_cursor is ref cursor;
open ref_cursor as select * from table_name;
end;

There are 2 types in this.
      1.strong ref cursor: This has a return type defined.
      2. weak ref cursor. this doesnt have a return type

normal cursor: Nothing but the named memory location. it has 2 types
      1. explicit cursor: Need to be defined  whenever required. only row 
      2.Implicit cursor: need not defined and used by oracle implicitly in DML operation.

CREATE OR REPLACE PACKAGE demo AS

  TYPE ref_cursor IS REF CURSOR;

  PROCEDURE GetEmployeesInDept(c OUT ref_cursor);

END demo;
/

CREATE OR REPLACE PACKAGE BODY demo AS

  PROCEDURE GetEmployeesInDept(c OUT ref_cursor)
  IS
  BEGIN
    RAISE NO_DATA_FOUND;
  END GetEmployeesInDept;

END demo;
/
?type sys_refcursor is ref cursor;?


DELIMITER //
DROP PROCEDURE IF EXISTS `usercontactsmodify`;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE `usercontactsmodify`() NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER 
BEGIN
  
   DEClARE usercontactmig_cur CURSOR FOR  SELECT num_invitation_link_sent,import_id, added_on FROM user_contacts_mig;	          
	 
	 SET v_id      = 0;
	 OPEN usercontactmig_cur;
          update_usercontacts: LOOP  
                             FETCH usercontactmig_cur INTO cmig_id ;
                             SELECT ?id    INTO ? ?v_id   ?? FROM user_contacts  ?? WHERE invitation_from = cmig_invitation_to AND invitation_to = cmig_invitation_from ;
								
		END LOOP update_usercontacts;
    CLOSE usercontactmig_cur;
     
END
//
DELIMITER ;
