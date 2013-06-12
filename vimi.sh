#!/bin/bash

VIMSETUPFILE="../setup.vim"
BACKUPDIR="../Backup"

tolower()
{
echo $1 | tr "[:upper:]" "[:lower:]" ;
}

toupper()
{
echo $1 | tr "[:lower:]" "[:upper:]" ;
}


function display_help
{
echo "Commands: "
echo " -new/-n name = create new problem-project with 'name' as name with Infoarena"
echo " template and opens it"
echo " -newcf/-ncf name = create new problem-project with 'name' as name with Codeforces"
echo " template and opens it"
echo " -open/-o name = open 'name' problem-project"
echo " -clean/-c name = clean everything compiler-related to 'name' use -all instead"
echo " of 'name' to clean every problem-project"
echo " -delete/-d name = delete everything (including source) related to project 'name'"
echo " use -all instead of 'name' to clean every problem-project"
echo " -ioclean/-ioc name = delete .in/.out of 'name' use -all instead of 'name' to apply"
echo " to every problem-project"
echo " -backup/-b = backup sources from all problem-projects in Backup folder"
echo " -help/-h = display this help"
}

function backup
{
NOW=$(date +"%Y-%m-%d-%H-%M-%S")
mkdir -p $BACKUPDIR
BACKUPFILE="BACKUP-$NOW"
find . -name '*.cpp' -type f -exec tar -czf $BACKUPDIR/$BACKUPFILE.tar.gz {} \;
echo "$BACKUPFILE.tar.gz generation complete!"
}

function clean_inout
{
rm -rf $1".in" $1".out"
echo "Deleted '$1.in' and '$1.out'"
}

function clean_inout_all
{
find . -name '*.in' -type f -exec rm -rf {} \;
find . -name '*.out' -type f -exec rm -rf {} \;
echo "Deleted all '*.in' and '*.out'"
}

function clean
{
rm -rf $VIMSETUPFILE $1".o" $1
echo "Cleaned '$1' project"
}

function clean_all
{
rm -rf $VIMSETUPFILE
find . -name '*.o' -type f -exec rm -rf {} \;
find . -perm /u+x -type f -exec rm -rf {} \;
echo "Cleaned all projects!"
}

function delete
{
rm -rf $1".cpp" $1".in" $1".out" $1".o" $1
echo "Deleted '$1' project"
}

function delete_all
{
rm -rf $VIMSETUPFILE
find . -name '*.o' -type f -exec rm -rf {} \;
find . -name '*.in' -type f -exec rm -rf {} \;
find . -name '*.out' -type f -exec rm -rf {} \;
find . -name '*.cpp' -type f -exec rm -rf {} \;
find . -perm /u+x -type f -exec rm -rf {} \;
echo "Deleted all projects"
}

function new_IA
{
exec 3<>$1
echo "/*" >&3
echo " PROB: "$4 >&3
echo " LANG: C++" >&3
echo "*/" >&3
echo "" >&3
echo "#include <fstream>" >&3
echo "" >&3
echo "#define DEBUG" >&3
echo "" >&3
echo "#ifndef DEBUG" >&3
echo " #define PRINT(x)" >&3
echo " #define D if(0)" >&3
echo "#else" >&3
echo " #include <iostream>" >&3
echo " #define PRINT(x) \\" >&3
echo " cout<<#x<<\":\\t\"<<x<<endl" >&3
echo " #define D if(1)" >&3
echo "#endif" >&3
echo "" >&3
echo "using namespace std;" >&3
echo "" >&3
echo "const char InFile[]=\""$2"\";" >&3
echo "const char OutFile[]=\""$3"\";" >&3
echo "" >&3
echo "ifstream fin(InFile);" >&3
echo "ofstream fout(OutFile);" >&3
echo "" >&3
echo "int main()" >&3
echo "{" >&3
echo " " >&3
echo " fin.close();" >&3
echo " " >&3
echo " fout.close();" >&3
echo " return 0;" >&3
echo "}" >&3
echo "" >&3
exec 3>&-

exec 3<>$INPUTFILE
exec 3>&-

exec 3<>$OUTPUTFILE
exec 3>&-

echo "New project '$1' created!"
}

function new_CF
{
exec 3<>$1
echo "/*" >&3
echo " PROB: "$4 >&3
echo " LANG: C++" >&3
echo "*/" >&3
echo "" >&3
echo "#include <cstdio>" >&3
echo "" >&3
echo "#ifdef ONLINE_JUDGE" >&3
echo " #define PRINT(x)" >&3
echo " #define D if(0)" >&3
echo "#else" >&3
echo " #include <iostream>" >&3
echo " #define PRINT(x) \\" >&3
echo " cout<<\"[DEBUG] \"<<#x<<\":\\t\"<<x<<endl" >&3
echo " #define D if(1)" >&3
echo "#endif" >&3
echo "" >&3
echo "using namespace std;" >&3
echo "" >&3
echo "const char InFile[]=\""$2"\";" >&3
echo "const char OutFile[]=\""$3"\";" >&3
echo "" >&3
echo "int main()" >&3
echo "{" >&3
echo "#ifndef ONLINE_JUDGE" >&3
echo " freopen(InFile,\"r\",stdin);" >&3
echo " freopen(OutFile,\"w\",stdout);" >&3
echo "#endif" >&3
echo " " >&3
echo " " >&3
echo " return 0;" >&3
echo "}" >&3
echo "" >&3
exec 3>&-

exec 3<>$INPUTFILE
exec 3>&-

exec 3<>$OUTPUTFILE
exec 3>&-

echo "New project '$1' created!"
}

function open
{
rm -rf $VIMSETUPFILE

exec 3<>$VIMSETUPFILE
echo ":e "$1 >&3
echo ":tabnew" >&3
echo ":e "$2 >&3
echo ":vsplit" >&3
echo ":wincmd w" >&3
echo "l" >&3
echo ":e "$3 >&3
echo ":wincmd w" >&3
echo "h" >&3
echo ":tabprev" >&3
exec 3>&-

sudo vim -S ../vimrc -s ../setup.vim
}
