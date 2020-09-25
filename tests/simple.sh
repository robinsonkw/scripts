#!/bin/bash
paths=$(awk -F ',' '{ print $1 }' filepaths)
files=$(awk -F ',' '{ print $2 }' filepaths)
col=$(awk -F ',' '{print $3}' filepaths)

function location {
for i in $(cat filepaths);
do
<<<<<<< HEAD
	location=$(awk -F "," '{print $1 "/" $2}' $i)
	column=$(awk -F "," '{print $3}' $i)
	echo $location
	echo $column
=======
	path=$(echo "$i" | awk -F ',' '{print $1}' "$i")
    echo $path    
done
}
for i in $(cat filepaths)
do
    echo $i
>>>>>>> 3e41167f710499ae840c5ae72da6ddd56244d347
done

#location

