:: Batch script to create GitHub contributors list
::
:: Script based off bash script on Linux
@echo off
set path='C:\Users\%username%\git-contribs\'
:: IF EXIST %path% ECHO Directory Exists!
::    ELSE

echo ****
echo Welcome to the GitHub Contributors script!
echo ****
set /p repo="Enter the repo name: "
set /p proj="Enter the project name: "
set git='https://github.com/'%proj%'/'%repo%'.git'
set gitpath=%path%'\'%repo%

if [ ! -d $gitpath ]
then 
    git -C $path clone $git
    git -C $gitpath log --all --format='%aN','%aE' | sort -u > ${path}/${repo}-contribs.csv
else
    git -C $gitpath log --all --format='%aN','%aE' | sort -u > ${path}/${repo}-contribs.csv
continue
fi

echo "Clone complete."

rm -rf ${path}/${repo}/

echo "Repository removed."

