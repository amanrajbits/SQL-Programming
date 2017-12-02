
DROP PROCEDURE if exists `get_thosands_ramdom_users`;
DELIMITER $$
CREATE PROCEDURE `get_thosands_ramdom_users`(in minid int(11), in maxid int(11) ) 
BEGIN

/*
create temporary table tmep_users as select id, email, 'p@ssw0rd' as password from users
 where active = 1 AND email_verified = 1 AND email is NOT null order by RAND() limit 10000;
 
update users u join tmep_users t  on u.id = t.id 
set u.password = MD5('p@ssw0rd');

select * from tmep_users;

*/


UPDATE users
SET password =MD5('p@ssw0rd')
where active = 1 AND email_verified = 1 AND email is NOT null 
AND id BETWEEN minid AND maxid ;

select email, 'p@ssw0rd' as password
from users
where active = 1 AND email_verified = 1 
AND email is NOT null
AND id BETWEEN minid AND maxid 
limit 10000;

END$$
DELIMITER ;
