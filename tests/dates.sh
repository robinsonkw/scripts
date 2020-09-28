#!/bin/bash
today=$(date +%Y%m%d)
datetest='inventory-'$today

function files {
files=$(find . -type f -print0 | xargs -0 ls -t)
while read file
    do
    ls -l "$file" | grep -e 'inventory-' | awk -F "/" '{print $2}'
    done <<< "$files" > /tmp/.list    
    #line=$(wc -l /tmp/.list)
    #if [ "$line" == "2" ]
    #    lists
    #else
    cat /tmp/.list | head -2 > /tmp/.lists
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

echo Today\'s file is $current.
echo The last file is $last.
}
files