#!/bin/bash

today=$(date +%Y%m%d)
home=$(pwd)

function filepath {

filenames=$(sed -n '3,$p' filepaths)

while read file
    do
    filepath=${home}$(echo $file | awk '{print $1}')
    filename=$(echo $file | awk '{print $2}')
    column=$(echo $file | awk '{print $3}')
    name=$(echo $file | awk '{print $4}')
    copyfile=${filepath}/${filename}
    inventoryfile=${name}-$today
    if [ $name == 'ddn' ]
    then
        ddnFile
        createFile
    else
        copyFile
        createFile
    fi
    inventory    
    done <<< "$filenames"
}
function copyFile {
    cp ${copyfile} ${home}/${inventoryfile}
    return
}
function createFile {    
    echo "" >> ${home}/${inventoryfile}
    echo $name Serial Numbers found on $today >> ${home}/$inventoryfile.sn
    echo ============ >> ${home}/$inventoryfile.sn
    cat ${home}/${inventoryfile} | \
        awk -v col=$column '{print $col}' >> ${home}/$inventoryfile.sn
    cat ${home}/${inventoryfile} | \
        awk -v col=$column '{print $col}' >> ${home}/inventory.csv
    return
}
function ddnFile {
    cat ${copyfile} >> ${home}/${inventoryfile}
    return   
}
function inventory {
    touch inventory-$today
    cat $inventoryfile.sn >> inventory-$today
    mv $inventoryfile.sn $inventoryfile
    mv $inventoryfile tmp
    return   
}

filepath

