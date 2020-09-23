#!/bin/bash
paths=$(awk -F ',' '{ print $1 }' filepaths)
files=$(awk -F ',' '{ print $2 }' filepaths)
col=$(awk -F ',' '{print $3}' filepaths)

for i in $(cat filepaths);
do
	location=$(awk -F "," '{print $1 "/" $2}' $i)
	column=$(awk -F "," '{print $3}' $i)
	echo $location
	echo $column
done


