#!/bin/sh
#/users/isso/DriveInventory
#Drive_inventory_DATE_TIME
today=$(date +%Y%m%d)
exec > /users/isso/DriveInventory/$today-drives

filepath='/users/isso'
location=$filepath'/DriveInventory'
filename='drive_inventory'
datetime=$(date +%H:%M:%S)
current_file=$(ls -tr | tail -n 1)
this_thursday=`date --date "Thursday" "+%m_%d_%Y"`
last_thursday=`date --date "last Thursday" "+%m_%d_%Y"`
old_file=`find $location -name ${filename}_${last_thursday}"*"`
new_file=`find $location -name ${filename}_${this_thursday}"*"`

echo "
Script compares the disk report for DriveInventory from Thursday to Thursday to detect
changes.  This script was last run on $today at $datetime.

If nothing follows this section then the report found no discrepancies.
*****************************************************************************
$old_file
$new_file

"
diff -i $old_file $new_file