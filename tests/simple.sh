#!/bin/bash

today=$(date +%Y%m%d)
home=$(pwd)

function filepath {

filenames=$(cat filepaths)

while read file
    do
    filepath=$(echo $file | awk '{print $1}')
    filename=$(echo $file | awk '{print $2}')
    column=$(echo $file | awk '{print $3}')
    name=$(echo $file | awk '{print $4}')
    copyfile=${filepath}/${filename}
    inventoryfile=${name}-$today
    if [ $name == 'ddn' ]
    then
        ddn
    else
        cp ${copyfile} ${home}/${inventoryfile}
        cat ${home}/${inventoryfile} | awk -v col=$column '{print $col}' > ${home}/$inventoryfile.sn
    fi
#    cp ${copyfile} ${home}/${inventoryfile}
#    cat ${home}/${inventoryfile} | awk -v col=$column '{print $col}' > ${home}/$inventoryfile.sn
    touch inventory-$today
    cat $inventoryfile.sn >> inventory-$today
    mv $inventoryfile.sn ${home}/tmp/$inventoryfile.sn
    done <<< "$filenames"
}

function ddn {
    
    status=$(echo $copyfile | grep "All")
    if [ "$status" == 'All' ]
    then 
    cat ${copyfile} >> ${home}/${inventoryfile}
    cat ${home}/${inventoryfile} | awk -v col=$column '{print $col}' > ${home}/$inventoryfile.sn
    else
    echo DDN error!
    echo DDN error! > ${home}/log.file
    fi

    return   
 
}

filepath

