create : $ tar cvf archive_name.tar dirname/ 
 
extract: $ tar xvf archive_name.tar

view : $ tar tvf archive_name.tar

gzip test.txt

gzip -d test.txt.gz

gzip -l *.gz

unzip test.zip

find: $ grep -i "the" demo_file


print 3 line later $ grep -A 3 -i "example" demo_text
print 3 line later $ grep -B <N> "string" FILENAME

$ grep -r "ramesh" "aman" *

$ grep "lines.*empty" demo_file

$ grep "lines.?empty" demo_file

upper case  :  grep -iw "is" demo_file  

inverse match:  $ grep -v "go" demo_text


find a fiels : find -iname "MyCProgram.c" 

LIST DIRE AND FILES:  ls -R  

List Home Directory:  ls ~

human read format : ls -lh  

time order: ls -ltr

ls redirection to output file: ls > out.txt

List files and directories with full path:   ls -d $PWD/* 

List directories only: ls -d */


get line number : grep -n "go" demo_text   : w next , B prev word, E - end 

vim file  : H, J, K 

grep -n -v  -e "sys" -e "the"  get_myday_event_count_by_date_range.sql

grep -c this demo_file

grep -v -c this demo_file

find all empty file : find ~ -empty

ssh -l jsmith remotehost.example.com

ssh -v -l jsmith remotehost.example.com

egrep -lRZ 'baba' . | xargs -0 -l sed -i -e 's/baba/aman/g'

grep -rl oldstring /path/to/folder | xargs sed -i s@oldstring@newstring@g

grep -rl aman | xargs sed -i s@aman@raj@g

find amanbaba -type f -name '*.sql' | xargs sed -i s@oldstring@newstring@g

find amanbaba -type f -name '*.sql' -exec sed -i -e 's/aman/raje/g' {} \;

Print all lines from /etc/passwd that has the same uid and gid   :   awk -F ':' '$3==$4' passwd

got to line no 143 : vim +143 filename.txt

vim -R /etc/passwd

$ vim +/search-term filename.txt


diff -w name_list.txt name_list_new.txt

sort names.txt  -- order by asc
sort -r names.txt -- desc 

find / -name *.jpg -type f -print | xargs tar -cvzf images.tar.gz

# cat url-list.txt | xargs wget –c


shutdown and power on: shutdown -h now

shutdown after 10 min: shutdown -h +10

reboot : shutdown -r now

reboot nd force the filesystem: shutdown -Fr now

halt
init 0 : sync and clean and shutdown 
init 6 reboot and by shuting completely 
poweroff : shut by power

reboot and shutdown command 

-- To connect to a remote server and download multiple files

$ ftp IP/hostname  
$ftp> mget *.html


file permission 

0 : no permission 
1 : execute 
2 : write  
3 : execute and write 
4 : 4 read 
5 : read and execute 
6 : read and write 
7 : all permission

owner: rwx 
grop : rwx
other: rwx 

CHMOD : 755 or rwxr-xr-x file name 
chmod ugo+rwx file.txt : user and group  and other 
chmod g-rwx file.txt  : Revoke all access 
chmod -R ug+rwx file.txt  : recursively  sub-directories


crontab -u system_username -l

# Minute   Hour   Day of Month       Month          Day of Week        Command    
# (0-59)  (0-23)     (1-31)    (1-12 or Jan-Dec)  (0-6 or Sun-Sat)         

EX: 0,5     2         12             *                *            /usr/bin/find


service ssh status

service ssh restart

service --status-all

ps -ef | more
ps -ef | grep 'aman'
ps -ef | grep vim 

top -u aman


file system disk space usage. in bytes : df -k   or df -h  df -T



 rm -i aman.sql : will get confirmatiob
 rmdire aman
 rm -i  *.sql
 rm -r example
 
cp -p file1 file2  : preserving mode, ownership and timestamp

cp -i file1 file2  : promot yes or no 

mv -v file1 file2 : show the procedure to rename 
mv -i file1 file2 : promot the rename 

cat -n /etc/logrotate.conf : with line number 

# mount /dev/sdb1 /u01  : manual mount 
  
# /dev/sdb1 /u01 ext2 defaults 0 2     : auto mount on restart


#change ownership :  chown user1 : user2 aman.sql

# change ownership : chown -R oracle:dba /home/oracle

 
change password : passwd

change password:  passwd aman 


mkdir ~/temp
mkdir -p dir1/dir2/dir3/dir4/


ifconfig -a

ifconfig eth0 up/down 

uname -a    :: Kernel name, Host name, Kernel release number, Processor type, etc.,

$ whereis ls  and whatis ls or locate crontab or 


print last 10 line :  tail filename.txt  

tail -n N filename.txt   :: N is number of last lines

tail -f log-file  :: growing log file 

less huge-log-file.log    ::::::::::::  CTRL+F – forward one window    ::      CTRL+B – backward one window


mysql -u root -p -h 192.168.1.2

su - username 

ping -c 5 gmail.com

sudo apt-get update

wget download-link 

different name# wget -O taglist.zip http://www.vim.org/scripts/download_script.php?src_id=7701

sudo apt-get install <Package_Name>

sudo apt-get update && sudo apt-get install <Package_Name>

sudo dpkg -i package.deb






































