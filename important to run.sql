alter TABLE user_remienders
modify snooze SMALLINT NOT NULL DEFAULT 0;

alter TABLE user_remienders
modify  snooze_time MEDIUMINT NOT NULL DEFAULT 0;

alter table user_schedules add replacement_id int(11);

SET time_zone = "+00:00";
SET @@session.time_zone = "+00:00";

DROP TRIGGER IF EXISTS `after_insert_user_schedule_receivers`;
DROP TRIGGER IF EXISTS `after_update_user_schedule_receivers`;
DROP PROCEDURE if exists `insert_monthly_calendar_sp`;
DROP TABLE IF EXISTS `current_month_reminders` ;
DROP PROCEDURE if exists `common_calendar_reminder_sp`;
DROP TABLE IF EXISTS `current_month_schedules` ;
DROP PROCEDURE if exists `common_calendar_schedule_sp`;
DROP TABLE IF EXISTS `current_month_todos` ;
DROP PROCEDURE if exists `common_calendar_todos_sp`;
DROP TABLE IF EXISTS `user_calendars` ;
drop  procedure if exists fill_schedule_Count_user_calendar_SP;
DROP procedure IF EXISTS `update_user_calendar_sp`;
DROP TRIGGER IF EXISTS `after_insert_user_remienders`;
DROP TRIGGER IF EXISTS `after_update_user_remiender_receivers`;
DROP TRIGGER IF EXISTS `after_insert_user_todos`;
DROP TRIGGER IF EXISTS `after_update_user_todo_receivers`;
drop  procedure if exists view_calendar_count_sp;
DROP PROCEDURE if exists `view_minicalendar_sp`;
drop  procedure if exists view_monthly_count_sp;
DROP PROCEDURE if exists `insert_minicalendar_sp`;

alter table user_todos modify todo_date datetime;

UPDATE mysql.user SET user='sagoon_dev', password=PASSWORD('root') WHERE user='root';

FLUSH PRIVILEGES;

CREATE USER 'sagoon_dev'@'%' IDENTIFIED BY 'root';

GRANT ALL PRIVILEGES ON * . * TO 'sagoon_dev'@'%';
FLUSH PRIVILEGES;

 
select CONVERT_TZ(a.start_date,'+00:00','+05:30'), a.* from user_schedules a ;

SELECT CONVERT_TZ(displaytime,'GMT','MET');

SELECT CONVERT_TZ('2017-09-19 12:30:00','+00:00','+05:30');

select SEC_TO_TIME(abs(TIMESTAMPDIFF( second, current_Date, '2017-09-18 08:30:00') ))  as dcs

alter table user_schedules
modify title varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL ,
modify description varchar(225) COLLATE utf8mb4_unicode_ci NOT NULL ;

alter table table_name
modify column_name varchar(length) COLLATE utf8mb4_unicode_ci NOT NULL ;

-- under procedure only for required variable/s:    

column_name  varchar(lenght) CHARSET utf8mb4;


SET GLOBAL log_bin_trust_function_creators = 1;

show variables like "log_bin_trust_function_creators";

show VARIABLES like  '%innodb_locks_unsafe_for_binlog%';

SELECT @@GLOBAL.tx_isolation, @@tx_isolation

select @@innodb_lock_wait_timeout

select @@innodb_deadlock_detect
