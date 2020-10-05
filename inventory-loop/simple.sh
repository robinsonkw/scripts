#!/bin/bash

today=$(date +%Y%m%d)
lastdate   # get line from classified side; runs in a function
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
        ddnFile         # the DDN file is different and on two racks, so need to concatenate the two files into one
                        # by appending the second ddn file to the first
        createFile
    else
        copyFile        # copy a regular file; no appending necessary
        createFile
    fi
    inventory           # runs the inventory function
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
    mv $inventoryfile archive/
    return   
}

# copy inventoryDiff function from high side; error checks for duplicate $today inventory file
# ensures that the diff that runs is still comparing yesterday and today
# declare the lastdate variable to be yesterday if lastdate == today

filepath

