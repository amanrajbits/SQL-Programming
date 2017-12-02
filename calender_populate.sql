DROP TABLE IF EXISTS system_calendars;
CREATE TABLE  `system_calendars` (
			id                      INTEGER PRIMARY KEY comment '/* year*10000+month*100+day */',
			db_date                 DATE NOT NULL,
			day_year                INTEGER NOT NULL,
			day_month               INTEGER NOT NULL comment ' 1 to 12', 
			day_num                 INTEGER NOT NULL comment '1 to 31' ,
			month_name              VARCHAR(9) NOT NULL comment '/* January, February...*/',
			day_quarter             INTEGER NOT NULL comment '1 to 4',
			day_week                INTEGER NOT NULL comment '1 to 52/53',
			week_day		SMALLINT(1) NOT NULL comment '0 to 6' ,
			day_name                VARCHAR(9) NOT NULL comment '/* Monday, Tuesday ...*/',
			holiday_flag            smallint(1) DEFAULT '0' CHECK (holiday_flag in (1,0)),
			weekend_flag            smallint(1) DEFAULT '0' CHECK (weekday_flag in (1,0)),
			day_event                   VARCHAR(50),			
			INDEX `calendarDateIdx` (`db_date` ASC),
			INDEX `calendarYearIdx` (`day_year` ASC)
		)ENGINE = InnoDB;



DROP PROCEDURE IF EXISTS fill_system_calendars;
DELIMITER //
CREATE PROCEDURE fill_system_calendars(IN startdate DATE,IN stopdate DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO system_calendars VALUES (					    
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                         MONTH(currentdate),
			             DAY(currentdate),
						DATE_FORMAT(currentdate,'%M'),	
						QUARTER(currentdate), 	
                         WEEKOFYEAR(currentdate),
						weekday(currentdate),
						DATE_FORMAT(currentdate,'%W'),
                         0,
                        CASE DAYOFWEEK(currentdate) WHEN 1 THEN 1 WHEN 7 then 1 ELSE 0 END,
                        NULL);

        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);

    END WHILE;
END //
DELIMITER ;

call fill_system_calendars('2017-01-01', '2021-01-01');

