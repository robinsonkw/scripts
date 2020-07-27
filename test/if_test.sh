#!/bin/bash
#---------
# variables
#---------
path="/Users/KevinRobinson/Documents/LANL/scripts"  # define the path to be used
dir="test" # define the directory to look for
today="20200610"
yesterday="20200609"

#-----
# code
#-----
if ! [ -d ${path}/${dir} ]; 
then
    mkdir ${path}/${dir}
    echo "Directory "$dir" created!"
    test="yes"
else
    test="yes"
    continue
fi

if [ $test==yes ];
then
    echo "it exists"
else
    echo "not there"
    end
fi

if [ -e ${path}/${dir}/${today}-testfile.log ] && [ -e ${path}/${dir}/${yesterday}-testfile.log ];
    then
    oldfile=${path}/${dir}/${yesterday}"-testfile.log"
    newfile=${path}/${dir}/${today}"-testfile.log"
    diff $oldfile $newfile > ${path}/${dir}/${today}-testfile.diff
    echo "diff file completed!"
    filename=${path}/${dir}/${today}"-testfile.diff"
    printf "%s" "$(<"$filename")"

fi
