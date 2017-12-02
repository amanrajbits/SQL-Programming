create table if not exists test.all_tables_bkp as select * from information_schema.tables;  
create table if not exists test.all_columns_bkp as select * from information_schema.columns; 
create table if not exists test.all_trigger_bkp as select * from information_schema.TRIGGERS; 
create table if not exists test.all_procedures_bkp as select * from information_schema.routines;  
create table if not exists test.all_indexes_bkp as select * from information_schema.STATISTICS;  

create table if not exists test.all_tables_bkp as select * from information_schema.tables; 

select * from  information_schema.tables a left join  test.all_tables_bkp b 
on   a.TABLE_SCHEMA =   b.TABLE_SCHEMA       
and a.TABLE_NAME = b.TABLE_NAME
and a.TABLE_TYPE = b.TABLE_TYPE
and a.CREATE_TIME = b.CREATE_TIME
and a.ENGINE = b.ENGINE
where b.TABLE_NAME is NULL
union all
select * from  information_schema.tables a right join  test.all_tables_bkp b 
on   a.TABLE_SCHEMA =   b.TABLE_SCHEMA       
and a.TABLE_NAME = b.TABLE_NAME
and a.TABLE_TYPE = b.TABLE_TYPE
and a.CREATE_TIME = b.CREATE_TIME
and a.ENGINE = b.ENGINE
where a.TABLE_NAME is NULL ;
    
-- select * from test.all_tables_bkp ;                             
                            
create table if not exists test.all_procedures_bkp as select * from information_schema.routines;  

select * from  information_schema.ROUTINES a left join  test.all_procedures_bkp b 
on   a.ROUTINE_SCHEMA =   b.ROUTINE_SCHEMA       
and a.ROUTINE_NAME = b.ROUTINE_NAME
and a.ROUTINE_TYPE = b.ROUTINE_TYPE
and a.CREATED = b.CREATED
and a.last_altered = b.last_altered
where b.ROUTINE_NAME is NULL
union all
select * from  information_schema.routines a right join  test.all_procedures_bkp b 
on   a.ROUTINE_SCHEMA =   b.ROUTINE_SCHEMA       
and a.ROUTINE_NAME = b.ROUTINE_NAME
and a.ROUTINE_TYPE = b.ROUTINE_TYPE
and a.CREATED = b.CREATED
and a.last_altered = b.last_altered
where a.ROUTINE_NAME is NULL ;
   
-- select * from test.all_procedures_bkp ;     

                            
create table if not exists test.all_trigger_bkp as select * from information_schema.TRIGGERS; 

select * from  information_schema.TRIGGERS a left join  test.all_trigger_bkp b 
on   a.TRIGGER_SCHEMA =   b.TRIGGER_SCHEMA       
and a.TRIGGER_NAME = b.TRIGGER_NAME
and a.EVENT_MANIPULATION = b.EVENT_MANIPULATION
and a.action_statement = b.action_statement
where b.TRIGGER_NAME is NULL
union all
select * from  information_schema.TRIGGERS a right join  test.all_trigger_bkp b 
on   a.TRIGGER_SCHEMA =   b.TRIGGER_SCHEMA       
and a.TRIGGER_NAME = b.TRIGGER_NAME
and a.EVENT_MANIPULATION = b.EVENT_MANIPULATION
and a.action_statement = b.action_statement
where a.TRIGGER_NAME is NULL ;                                 
                                                                  
-- select * from test.all_trigger_bkp ;    

create table if not exists test.all_columns_bkp as select * from information_schema.columns;  

select * from  information_schema.columns a left join  test.all_columns_bkp b 
on   a.TABLE_SCHEMA =   b.TABLE_SCHEMA       
and a.TABLE_NAME = b.TABLE_NAME
and a.COLUMN_NAME = b.COLUMN_NAME
and a.ORDINAL_POSITION =b.ORDINAL_POSITION
and a.COLUMN_TYPE = b.COLUMN_TYPE
and a.IS_NULLABLE = b.IS_NULLABLE
and a.EXTRA = b.EXTRA
and coalesce(a.COLUMN_DEFAULT,0) = coalesce(b.COLUMN_DEFAULT,0)
and coalesce(a.COLLATION_NAME,0) = coalesce(b.COLLATION_NAME,0)
where b.COLUMN_NAME is NULL
union all
select * from  information_schema.columns a right join  test.all_columns_bkp b 
on   a.TABLE_SCHEMA =   b.TABLE_SCHEMA       
and a.TABLE_NAME = b.TABLE_NAME
and a.COLUMN_NAME = b.COLUMN_NAME
and a.ORDINAL_POSITION =b.ORDINAL_POSITION
and a.COLUMN_TYPE = b.COLUMN_TYPE
and a.IS_NULLABLE = b.IS_NULLABLE
and a.EXTRA = b.EXTRA
and coalesce(a.COLUMN_DEFAULT,0) = coalesce(b.COLUMN_DEFAULT,0)
and coalesce(a.COLLATION_NAME,0) = coalesce(b.COLLATION_NAME,0)
where a.COLUMN_NAME is NULL;

-- select * from test.all_columns_bkp ;    

create table if not exists test.all_indexes_bkp as select * from information_schema.STATISTICS;  

select * from  information_schema.STATISTICS a left join  test.all_indexes_bkp b 
on  a.TABLE_SCHEMA =   b.TABLE_SCHEMA       
and a.TABLE_NAME = b.TABLE_NAME
and a.INDEX_NAME = b.INDEX_NAME
and a.INDEX_SCHEMA =  b.INDEX_SCHEMA   
and a.SEQ_IN_INDEX = b.SEQ_IN_INDEX
and a.COLUMN_NAME = b.COLUMN_NAME
and a.INDEX_TYPE = b.INDEX_TYPE
where b.INDEX_NAME is NULL
union all
select * from  information_schema.STATISTICS a right join  test.all_indexes_bkp b 
on  a.TABLE_SCHEMA =   b.TABLE_SCHEMA       
and a.TABLE_NAME = b.TABLE_NAME
and a.INDEX_NAME = b.INDEX_NAME
and a.INDEX_SCHEMA =  b.INDEX_SCHEMA   
and a.SEQ_IN_INDEX = b.SEQ_IN_INDEX
and a.COLUMN_NAME = b.COLUMN_NAME
and a.INDEX_TYPE = b.INDEX_TYPE
where a.INDEX_NAME is NULL;
    
-- select * from test.all_indexes_bkp ; 

                                                       
