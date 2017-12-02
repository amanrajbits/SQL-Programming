SET time_zone = "+00:00";
SET @@session.time_zone = "+00:00";

UPDATE mysql.user SET user='dev', password=PASSWORD('root') WHERE user='root';

FLUSH PRIVILEGES;

CREATE USER 'dev'@'%' IDENTIFIED BY 'root';

GRANT ALL PRIVILEGES ON * . * TO 'dev'@'%';

FLUSH PRIVILEGES;

select CONVERT_TZ(a.start_date,'+00:00','+05:30'), a.* from schedules a ;

SELECT CONVERT_TZ(displaytime,'GMT','MET');

SELECT CONVERT_TZ('2017-09-19 12:30:00','+00:00','+05:30');

select SEC_TO_TIME(abs(TIMESTAMPDIFF( second, current_Date, '2017-09-18 08:30:00') ))  as dcs

modify description varchar(225) COLLATE utf8mb4_unicode_ci NOT NULL ;

alter table table_name
modify column_name varchar(length) COLLATE utf8mb4_unicode_ci NOT NULL ;

-- under procedure only for required variable/s:

column_name varchar(lenght) CHARSET utf8mb4;


SET GLOBAL log_bin_trust_function_creators = 1;

show variables like "log_bin_trust_function_creators";

show VARIABLES like  '%innodb_locks_unsafe_for_binlog%';

SELECT @@GLOBAL.tx_isolation, @@tx_isolation

select @@innodb_lock_wait_timeout

select @@innodb_deadlock_detect
