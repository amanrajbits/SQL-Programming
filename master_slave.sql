------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
https://mariadb.com/kb/en/library/binary-log-formats/
-- Changing the binary log format on a master has no affect on the slave's binary log format.

SET GLOBAL binlog_format=ROW;

SET SESSION binlog_format=MIXED;

SET binlog_format= STATEMENT;

statement : with temp table unsafe and it is default : SQL statements that make changes to the data or structure of a table
row based : +> binlog-format=ROW  : Records events affecting individual table rows.  
mix based : for AUTO_INCREMENT, INSERT-DELAYED statements, UUID(), USER(), CURRENT_USER(), LOAD_FILE(),  ROW_COUNT() or FOUND_ROWS(),  system variable, user-defined function, auto switch on used of temp table 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

https://dzone.com/articles/how-identify-and-cure-mysql

MASTER to REAL SLAVE: To release extra binlog bandwith create dummy process to get replicatable statments : https://stackoverflow.com/questions/4593496/what-is-the-purpose-of-mysqls-blackhole-engine

setup: https://dev.mysql.com/doc/refman/5.7/en/replication-options-slave.html

SHOW MASTER STATUS;

Read_Master_Log_Pos  and Exec_Master_Log_Pos

Seconds_Behind_Master

enable /disable : "slave_compressed_protocol"  : disable binary logging on slave  : slave IO_THREAD lag  

enable and config : "log_slow_slave_statements" : long_query_time 

setting the configuration option "log_slow_verbosity" to “full”.

use_global_long_query_time and use_global_log_slow_control =long_query_time

log_slow_verbosity =profiling 

log_slow_verbosity = innodb 

Here is how you can setup pt-stalk so that it captures diagnostic data when there is slave lag:

------- pt-plug.sh contents
#!/bin/bash
trg_plugin() {
mysqladmin $EXT_ARGV ping &> /dev/null
mysqld_alive=$?
if [[ $mysqld_alive == 0 ]]
then
seconds_behind_master=$(mysql $EXT_ARGV -e "show slave status" --vertical | grep Seconds_Behind_Master | awk '{print $2}')
echo $seconds_behind_master
else
echo 1
fi
}
# Uncomment below to test that trg_plugin function works as expected
#trg_plugin
-------
-- That's the pt-plug.sh file you would need to create and then use it as below with pt-stalk:
						
						
$ /usr/bin/pt-stalk --function=/root/pt-plug.sh --variable=seconds_behind_master --threshold=300 --cycles=60 --notify-by-email=muhammad@example.com --log=/root/pt-stalk.log --pid=/root/pt-stalk.pid --daemonize
						
it means that if seconds_behind_master value is >= 300 for 60 seconds or more then pt-stalk will start capturing data. Adding –notify-by-email option will notify via email when pt-stalk captures data.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
												
https://mariadb.com/resources/blog/goodbye-replication-lag

STOP SLAVE SQL_THREAD;
SET GLOBAL slave_parallel_threads = 4;
START SLAVE SQL_THREAD;
SELECT @@slave_parallel_threads;  Range: 0 to 16383

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

https://mariadb.com/kb/en/library/replication-and-binary-log-server-system-variables/#slave_parallel_threads

auto_increment_increment ( deffault 1 to 65535 )	

auto_increment_offset
						
binlog_annotate_row_events

binlog_checksum
						
binlog_commit_wait_count

binlog_commit_wait_usec

binlog_direct_non_transactional_updates	: OFF (0)					

binlog_format : ROW, STATEMENT or MIXED
						
binlog_optimize_thread_scheduling or skip-binlog-optimize-thread-scheduling  : ON
						
binlog_row_image : FULL, NOBLOB [ Binary large object - Blobs are typically images, audio or other multimedia objects] or MINIMAL 						

binlog_stmt_cache_size

default_master_connection
encrypt_binlog : OFF
expire_logs_days
init_slave
log_bin
log_bin_basename						
log_bin_compress_min_len:   Minimum length of sql statement  : 10 to 1024
master_retry_count : defaault 86400						
log_slave_updates : by defualt set to 0						
master_verify_checksum: 	 OFF (0)	
slave_sql_verify_checksum:   ON (1)						
log_slow_slave_statements:	ON  (>= MariaDB 10.2.4), OFF (<= MariaDB 10.2.3)				
max_binlog_cache_size : Default Value: 18446744073709547520 Range: 4096 to 18446744073709547520
skip_parallel_replication : OFF
skip_replication : OFF
slave_compressed_protocol: DEFAULT 0 
slave_domain_parallel_threads :						
slave_parallel_mode : optimistic: tries to apply most transactional DML in parallel, and handles any conflicts with rollback and retry
					 conservative: limits parallelism in an effort to avoid any conflicts
					 aggressive tries to maximise the parallelism, minimal,
					 minimal: only parallelizes the commit steps of transactions.
					 none disables parallel apply completely.
						
slave_run_triggers_for_rbr: default 0 for slave as no need to run trigger  : IF trigger for slave only then YES -- https://mariadb.com/kb/en/library/running-triggers-on-the-slave-for-row-based-events/
slave_skip_errors : default OFF but -- set slave-skip-errors = [ error_code1,error_code2,...|all|ddl_exist_errors]   -- https://mariadb.com/kb/en/library/mariadb-error-codes/						
						
sql_slave_skip_counter : default 0  : SET GLOBAL sql_slave_skip_counter ??
sync_binlog :  default is 0, in which case the operating system handles flushing the file to disk. 1 is the safest, but slowest,
sync_relay_log : 1 safest : If the disk has cache backed by battery, synchronization will be fast and a more conservative number can be chosen.
sync_relay_log_info: 1 						
						
										
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						
VARCHAR2 does not distinguish between a NULL and empty string  : min size-1 and max-4000  : if you enter value less than 10 then remaining space is automatically deleted
												
VARCHAR is variable-length. : ( min-1 to max-4000) but 255 to 65,535 characters : Uses dynamic memory allocation. To support distinction between NULL and empty string in future, as ANSI standard prescribes.
						
CHAR is fixed length. of 255  char : It's 50% faster than VARCHAR. static memory allocation.

star topology every computer is connected to a central node called a hub or a switch
						
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

count(*) which memory engine is being used : 
						
create temp table memory = engine in place of innodb						

under what conditions does your database invalidate caches

when does it sort on disk rather than in memory, when does it need to create temporary tables, etc						

Basically, First sort small chunks of data first, write it back to the disk and then iterate over those to sort all. 
						
utilize an index for all of the criteria in the WHERE clause and to reduce the size of the result set, add a "multi-column index"  table:
						
Removing the unnecessary JOINs  and we should hint or force the multi-column index.	
						
Move Queries to Stored Procedures (SP) [many queries in one SP] as can stay on the [server] [so it is faster] until the final results are returned. SP keeps DB access code separate from your presentation layer which makes it easier to maintain (3 tiers model).
						
Remove unnecessary paratheses and Remove unneeded Views or Sorting or Grouping  

Never use "Select *" -- Specify only the fields you need; it will be faster and will use less bandwidth.

Use Indexes on Integers, Booleans, and Numbers. not on Blobs, VarChars and Long Strings. "If you do many updates on that field, maintaining indexes might take more time than it saves"						
						
Benchmark :  Under what circumstances am I generating bad queries?

Profile: configuration, memory, CPU, network, disk I/O  

Turn On MySQL slow query log						

EXPLAIN, EXPLAINEXTENDED, SHOW STATUS, and SHOW PROCESSLIST

--> https://dev.mysql.com/doc/refman/5.7/en/partitioning-subpartitions.html
						
Partition Your Tables : RANGE partitioning: PARTITION BY RANGE( YEAR(column_date) ) ( PARTITION p0 VALUES LESS THAN (1960),PARTITION p1 VALUES LESS THAN (1970), PARTITION p4 VALUES LESS THAN MAXVALUE);
					    LIST partitioning:  PARTITION BY LIST(c1) (  PARTITION p0 VALUES IN (1, 4, 7) , PARTITION p1 VALUES IN (2, 5, 8) );
					    KEY partitioning:   PARTITION BY KEY(column) PARTITIONS 6; 
						HASH partitioning:  PARTITION BY LINEAR HASH( YEAR(hired) ) PARTITIONS 4;	
								       Ex:  CREATE TABLE ts (id INT, purchased DATE) PARTITION BY RANGE( YEAR(purchased) ) SUBPARTITION BY HASH ( TO_DAYS(purchased) )
																 SUBPARTITIONS 2 ( PARTITION p0 VALUES LESS THAN (1990), PARTITION p1 VALUES LESS THAN (2000),PARTITION p2 VALUES LESS THAN MAXVALUE );
                                        Ex: PARTITION BY RANGE( YEAR(purchased) ) SUBPARTITION BY HASH( TO_DAYS(purchased) ) ( PARTITION p0 VALUES LESS THAN (1990) ( SUBPARTITION s0,SUBPARTITION s1 ),

Engine: SHOW PLUGINS; ALTER TABLE table_name ENGINE = INNODB; SELECT  PLUGIN_NAME as Name, PLUGIN_VERSION as Version, PLUGIN_STATUS as Status FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_TYPE='STORAGE ENGINE';	
SQL NOT IN C : canonical procedural programming language : SubQuery Should be in JOIN 
						
-- to create table :: https://dev.mysql.com/doc/refman/5.7/en/create-table.html  : CREATE TABLE new_tbl AS SELECT * FROM orig_tbl;
						
Tighten Up Your Schema : normalization results in a minimization of redundant data, isertion anomaly, update anomaly & deletion anomaly. 1NF, 2NF, 3NF and BCNF in Database
						1NF :comma seperated to extra rows  : Multiple Columns -> Unique/Primary Keys, 
						2NF :comma seperated to extra table and rows:  mininal columns candidate key 
						3NF : create transitive dependency if possible 
						BCNF: Boyce–Codd normal form: Non Trivial form of 3NF
						
Don't Overuse Artificial Primary Keys , like  UNIQUE INDEX(post_id, tag_id)	:  Artificial primary keys are nice because they can make the schema less volatile		
						
Composite key is a key that has more than one column : uniquely identifies a row it is also a Super key.
Primary Key: is the preferable columns you choose to maintain uniqueness in a table						
Super key is any combination of columns that uniquely identifies a row in a table. we can remove extra attribtes without losing the unique identification property.
A candidate key is always a super key which cannot have any columns removed from it without losing the unique identification property. This property is  known as minimality or (better) irreducibility.
Alternate or secondary Key : the alternate keys of Primary Key which give unique tuple						
Foreign key is the column of a table which points to the primary key of another table. They act as cross reference between tables.					

												CREATE TABLE customer (
												  id INT NOT NULL AUTO_INCREMENT,
												  firstname varchar(50) NOT NULL,
												  lastname varchar(50) NOT NULL,
												  PRIMARY KEY (id)
												) ENGINE=INNODB;

												CREATE TABLE contact (
												  id INT,
												  customer_id INT,
												  info varchar(50) NOT NULL,
												  type varchar(50) NOT NULL,
												  INDEX par_ind (customer_id),
												  FULLTEXT INDEX par_indname (customer_name),
												  CONSTRAINT fk_customer FOREIGN KEY (customer_id)  REFERENCES customer(id)  ON DELETE CASCADE  ON UPDATE CASCADE
												) ENGINE=INNODB;
						
						
Optimization: instead of direct min or max , we can use previously calculated value in where clause ( < and > )
						
SQL explain Plan : select (cost), Parallelism (Gather Streams, Repartition), Merge Join , Clustered Index Scan, Nested Loops, (Physcial and Logical Operations), 
				: Estimated: I/O cost, CPU Cost , Number of Executions, Operator Cost, SubTree Cost, Number of Rows , Actual Rebinds, Actual Rewinds, Node Id
						
Mysql Explain Plan: 
						
SYSTEM	Blue			Single row: system constant		 Very low cost
CONST	Blue			Single row: constant			 Very low cost
EQ_REF	Green			Unique Key Lookup				 Low cost -- The optimizer is able to find an index . It is fast because the index search directly leads to the page with all the row data
FULLTEXT Yellow			Fulltext Index Search			 Low -- for this specialized search requirement
UNIQUE_SUBQUERY	Orange	Unique Key Lookup into table of subquery	Low -- Used for efficient Subquery processing
INDEX_SUBQUERY	Orange	Non-Unique Key Lookup into table of subquery	Low -- Used for efficient Subquery processing							
						
REF		    Green		Non-Unique Key Lookup			 Low-medium -- Low if the number of matching rows is small; higher as the number of rows increases		
REF_OR_NULL	Green		Key Lookup + Fetch NULL Values	 Low-medium -- if the number of matching rows is small; 	higher as the number of rows increases						

INDEX_MERGE	Green		Index Merge						Medium -- look for a better index selection in the query to improve performance
RANGE	Orange			Index Range Scan				Medium -- partial index scan
						
INDEX	Red	Full Index Scan	High -- especially for large indexes;
						
ALL	Red	Full Table Scan	Very High -- very costly for large tables, less impact for small ones. No usable indexes which forces the optimizer to search every row. 	
						
UNKNOWN	Black	unknown	Note: This is the default, in case a match cannot be determined

-- http://mechanics.flite.com/blog/2014/02/14/faster-json-parsing-using-mysql-json-udfs/					
						
http://howto-use-mysql-spatial-ext.blogspot.in/
	containing geographic data named Points. Spatial table. location Point NOT NULL,   
	INSERT INTO Points (name, location) VALUES ( 'point1' , GeomFromText( ' POINT(31.5 42.2) ' ) ) 	
	SELECT name, AsText(location) FROM Points; 
	SELECT name, AsText(location) FROM Points WHERE X(location) < style="font-weight: bold;">Y(location) > 12; 

B-Tree INDEX: b-tree indexes are used for high cardinaties, usuall when we have too many distinct columns.						
            : Dont benefit on 1. Low-cardinality columns with less than 200 distinct values [Bitmapped indexes required],  2. No support for SQL functions [ function based index only in SQL SERVER ]			

Bitmap index are used for low cardinaties,  usually when we have repeated columns. Generally MySQL create b-tree index automatically and mysql doesnt support bitmap index	

B-tree index updates on key values has relatively inexpensive, where as Bitmap index has more expensive.

selection of columns for INDEX : If you do many updates on that field/s, maintaining indexes might take more time than it saves and try b-tree index only for high cardinality > 200

MyISAM is good for read-heavy data and InnoDB is good for write-heavy data 
MyISAM keeps an internal cache of table meta-data like the number of rows. But innodb has SQL_CALC_FOUND_ROWS [SELECT FOUND_ROWS() ] to count rows for LIMIT 2,4  (means leave 2 row and get 4 rows ] Purpose.	INSERT DELAYED into table_name : insert queue to baloon

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


						

						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
