#!/bin/bash

# Test script to determine if data from a column is present, if not go to next column

file='test.info'
count=$(head -n 1 $file | awk '{ print NF; exit}')
h=$(grep -n "-" $file | awk -F  ':' '{ print $1 }')
(( h=h+1 ))

function printcolumn() {
if [[ "$count" == 3 ]]
    then
    text=$(tail -n +$h $file | awk -v col=$count '{ print $col }')
    else
    echo count does not equal.
fi
}

function columntest() {
    if [ -z "$text" ]
    then
        echo columnb is null
    else
        echo $text
    fi
}

printcolumn
columntest
