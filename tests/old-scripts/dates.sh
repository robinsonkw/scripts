#!/bin/bash
today=$(date +%Y%m%d)
datetest='inventory-'$today
if ! [ -e inventory-$today ]
then
    touch -t ${today}0100.00 inventory-${today}
fi

rm /tmp/.list*

function files {
#files=$(find . -type f -print0 | xargs -0 ls -t)
#while read file
#    do
#    ls -1l "$file" | grep -e 'inventory-' | awk -F "/" '{print $2}'
#    done <<< "$files" > /tmp/.list    
    #line=$(wc -l /tmp/.list)
    #if [ "$line" == "2" ]
    #    lists
    #else
#chmod 644 /tmp/.list
ls -1p | grep -v / | grep -e "inventory-" | sort -r > /tmp/.list
length=$(wc -l /tmp/.list | awk '{print $1}')

if [ "$length" > 2 ]; then
    cat /tmp/.list | head -2 > /tmp/.lists
fi
    diff /tmp/.lists /tmp/.list | sed -n '2,$p' | awk -F "> " '{print $2}' > /tmp/.listdiff
    lists
}

function lists {
lists=$(cat /tmp/.lists)
    while read list    #grep -e 'inventory-'
        do
        if [ "$list" == "$datetest" ]
        then
            declare current=$list
            #echo $current is True
        else
            declare last=$list
            #echo $last is False
        fi
    done <<< "$lists"
    inventory
}
function archives {
    for i in $(cat /tmp/.listdiff)
        do
        mv  ./$i ./archive/$i
        done
}
function inventory {
    echo Doing the inventory.
    archives
}

files

