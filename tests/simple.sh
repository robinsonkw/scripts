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
        ddn
        createFile
    else
        createFile
    fi
#    cp ${copyfile} ${home}/${inventoryfile}
#    cat ${home}/${inventoryfile} | awk -v col=$column '{print $col}' > ${home}/$inventoryfile.sn
    touch inventory-$today
    cat $inventoryfile.sn >> inventory-$today
    mv $inventoryfile.sn $inventoryfile
    mv $inventoryfile tmp
    done <<< "$filenames"
}
function createFile {    
    cp ${copyfile} ${home}/${inventoryfile}
    echo "" >> ${home}/${inventoryfile}
    echo $name Serial Numbers found on $date >> ${home}/$inventoryfile.sn
    echo ============ >> ${home}/$inventoryfile.sn
    cat ${home}/${inventoryfile} | \
        awk -v col=$column '{print $col}' >> ${home}/$inventoryfile.sn
    return
}
function ddn {
    
#    status=$(echo $copyfile | grep "All")
#    if [ $status = 'All' ]
#    then 
    cat ${copyfile} >> ${home}/${inventoryfile}
#    cat ${home}/${inventoryfile} | awk -v col=$column '{print $col}' > ${home}/$inventoryfile.sn
#    else
#    echo DDN error!
#    echo DDN error! > ${home}/log.file
#    fi
    return   
}

filepath

