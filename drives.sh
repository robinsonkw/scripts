#!/bin/sh

## VARIABLES ##
#/users/isso/DriveInventory
#Drive_inventory_DATE_TIME
today=$(date +%Y%m%d)
yesterday=$(date --date "Yesterday" "+%Y%m%d")
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

    if [ -e ${INVENTORYPATH}${DDNFILE1} ]; then
        

}

header(){
echo "
Script compares the disk report for drive inventories daily to track changes to
drive and tape inventories.  This script was last run on $yesterday at $datetime.
"
}
