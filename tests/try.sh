#!/bin/bash
today=$(date +%Y%m%d)
datetest='inventory-'$today

for i in $(cat /tmp/.list)
    do
    if ! [ "$i" == "$datetest" ]
    then
        mv $i archive/$i
    fi
done

