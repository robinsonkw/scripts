#!/bin/bash

# Test script to determine if data from a column is present, if not go to next column

file='test.info'
count=$(head -n 1 $file | awk '{ print NF; exit}')
h=$(grep -n "-" $file | awk -F  ':' '{ print $1 }')
(( h=h+1 ))

if [[ "$count" == 3 ]]
    then
    tail -n +$h $file | awk -v col=$count '{ print $col }'
    else
    echo count does not equal.
fi

