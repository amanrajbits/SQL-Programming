$ git init
$ git add --a 
$ git commit -m "comment"
$ git push -u origin master
$ git config --global user.name "Scott Chacon"
$ git config --global user.email "schacon@gmail.com"

git add -A
git status
git commit -m "Tech Support update procedures added"
git fetch
git reset --hard origin/master
git add -u
source ~/.bashrc
ptg master	
git -c user.name="Aman Raj" -c user.email=aman.raj@mettl.com commit --amend --reset-author

git pull 
git merger --abort
git fetch
git res --h  or  m

git reset --hard origin/master
git fetch && git rebase


cd d:
cd Projects/Mettl
cd common
mvn clean install -DskipTests
$ mvn clean install -DskipITs  ----- to build

Use Git commands to help keep track of changes made to a project:
git init creates a new Git repository
git status inspects the contents of the working directory and staging area
git add adds files from the working directory to the staging area
git diff shows the difference between the working directory and the staging area
git commit permanently stores file changes from the staging area in the repository
git log  shows a list of all previous commits

git show HEAD
git checkout HEAD filename
git add filename_1 filename_2
git reset HEAD filename

git reset 5d69206  --  SHA = 5d692065cf51a2f50ea8e7b19b5a7ae512f633ba

git diff
git checkout
git merge branchname 

git branch -d clean_up

git branch: Lists all a Git project's branches.
git branch branch_name: Creates a new branch.
git checkout branch_name: Used to switch from one branch to another.
git merge branch_name: Used to join file changes from one branch to another.
git branch -d branch_name: Deletes the branch specified

git clone remote_location clone_name
git remote -v
git fetch
git merge origin/master


cd ~
git branch
git statsh
git pull origin branch_name

git add filename

git commit -m "cooment"
git push -u origin master 


sudo chmod -R 0777 DbVisualizer

grep -ir  user_sessions a2live_31oct17.sql

mysql -uroot -p dev < migration_script.sql 

sudo dpkg -i bcompare-4.2.3.22587_amd64.deb

sudo openvpn client.ovpn
/home/aman/private

sudo apt-get purge google-chrome-stable
sudo apt-get autoremove

sudo update-rc.d -f openvpn  remove