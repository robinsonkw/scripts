#!/bin/bash

clear

#ping=$(ping -c 1 )
#up=$($ping $i | grep '1 packets received')

while read $i
do
    up=$(ping -c 1 $i | grep '1 packets received')
    if [[ ! -z "$up" ]]
    then echo "Host up"
    else echo "Host down"
    fi
done<hosts
