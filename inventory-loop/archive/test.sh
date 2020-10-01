#!/bin/sh

## VARIABLES ##
#/users/isso/DriveInventory
#Drive_inventory_DATE_TIME
if [ ! $OSTYPE=='darwin' ]; then
    echo This system uses Linux/GNU date formatting.
    today=$(date +%Y%m%d)
    yesterday=$(date --date="Yesterday" +%Y%m%d)
    twodays=$(date --date="2 days ago" +%Y%m%d)
else
    echo This is a Mac. It uses BSD date fornatting.
    today=$(date +%Y%m%d)
    yesterday=$(date -j -v -1d +%Y%m%d)
    twodays=$(date -j -v -2d +%Y%m%d)
fi

DDNPATH='/users/isso/DriveInventory/DDN/status/'
DDNFILE1='status-sys01'
DDNFILE2='status-sys02'
IDMGRPATH='/users/isso/host-based-disks-inventory/'
IDMGRFILE='disksInventory.log.idmgr.*'
CREMPATH='/archive/isso'
WICKERSHAM='wickershams_disk_inv'
SAM='sam-i-am_disk_inv'
STORAGE='storagens2_disk_inv'
NETAPP='netapp_disk_inv'
DSM='dsmservns3_disk_inv'
INVENTORYPATH='/users/isso/inventory/'
INVENTORYARCHIVE='/users/isso/inventory/archive/'
#filepath='/users/isso'
#location=$filepath'/DriveInventory'
#filename='drive_inventory'
datetime=$(date +%H:%M:%S)
#current_file=$(ls -tr | tail -n 1)
#this_thursday=`date --date "Thursday" "+%m_%d_%Y"`
#last_thursday=`date --date "last Thursday" "+%m_%d_%Y"`
#old_file=`find $location -name ${filename}_${last_thursday}"*"`
#new_file=`find $location -name ${filename}_${this_thursday}"*"`

copies() {

    cp ${DDNPATH}${DDNFILE1}    ${INVENTORYPATH}${DDNFILE1}-$yesterday
    cp ${DDNPATH}${DDNFILE2}    ${INVENTORYPATH}${DDNFILE2}-$yesterday
    cp ${IDMGRPATH}${IDMGRFILE} ${INVENTORYPATH}${IDMGRFILE}-$yesterday
    cp ${CREMPATH}${WICKERSHAM} ${INVENTORYPATH}${WICKERSHAM}-$yeesterday
    cp ${CREMPATH}${SAM}        ${INVENTORYPATH}${SAM}-$yesterday
    cp ${CREMPATH}${STORAGE}    ${INVENTORYPATH}${STORAGE}-$yesterday
    cp ${CREMPATH}${NETAPP}     ${INVENTORYPATH}${NETAPP}-$yesterday
    cp ${CREMPATH}${DSM}        ${INVENTORYPATH}${DSM}-$yesterday    
}
ddn_compare() {

    if [ -e ${INVENTORYPATH}${DDNFILE1}-$yesterday ]; then
        if [ -e ${INVENTORYARCHIVE}${DDNFILE1}-$twodays ]; then
            DDN1DIFF=$(diff -i ${INVENTORYARCHIVE}${DDNFILE1}-$twodays ${INVENTORYPATH}${DDNFILE1}-$yesterday)
        else
            echo"${INVENTORYARCHIVE}$DDNFILE1-$twodays did not exist for conparisson purposes."
        fi
    else
        echo"${INVENTORYPATH}$DDNFILE1-$yesterday did not exist for comparisson purposes."
    fi

    if test -z "$DDN1DIFF"; then
        echo "The variable DDN1DIFF is blank.  Correct to see output."
    else
        echo "
DDN Status 01

$DDN1DIFF >> ${INVENTORYPATH}'inventory-'$yesterday

"
    fi
}

header(){
echo "
Script compares the disk report for drive inventories daily to track changes to
drive and tape inventories.  This script was last run on $yesterday at $datetime.
"
}
