#!/bin/bash
paths=$(awk -F ',' '{ print $1 }' filepaths)
files=$(awk -F ',' '{ print $2 }' filepaths)

while read files; do
    printf "$paths"
    printf "$files"
    cat $paths/$files

done
exit


