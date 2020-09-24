#!/bin/bash
paths=$(awk -F ',' '{ print $1 }' filepaths)
files=$(awk -F ',' '{ print $2 }' filepaths)
col=$(awk -F ',' '{print $3}' filepaths)

function location {
for i in $(cat filepaths);
do
	path=$(echo "$i" | awk -F ',' '{print $1}' "$i")
    echo $path    
done
}
for i in $(cat filepaths)
do
    echo $i
done

#location

