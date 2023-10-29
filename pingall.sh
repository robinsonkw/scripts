#!/bin/bash

clear

#ping=$(ping -c 1 )
#up=$($ping $i | grep '1 packets received')

while read -r i
do
    up=$(ping -c 1 $i | grep '1 packets received')
    if [[ ! -z "$up" ]]
    then echo "$i is up"
    else echo "$i is down"
    fi
done<hosts
