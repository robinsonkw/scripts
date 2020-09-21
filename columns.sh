#!/bin/bash

# Test script to determine if data from a column is present, if not go to next column

file='test.info'
count=$(head -n 1 $file | awk '{ print NF; exit}')
if [[ "$count" == 3 ]]
    h=2
    then
    tail -n +$h $file | awk -v col=$count '{ print $col }'
    else
    echo count does not equal.
fi

