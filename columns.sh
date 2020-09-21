#!/bin/bash

# Test script to determine if data from a column is present, if not go to next column

file='test.info'
count="head -n 1 $file | awk '{ print NF; exit}'"
if [ -z "$count"==3 ]
    then
    tail -n +2 $file | awk '{ print $($count) }'
    else
    echo count does not equal.
fi

