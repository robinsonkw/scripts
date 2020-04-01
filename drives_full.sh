#!/usr/bin/env bash
today=$(date +%Y%m%d)
exec > /users/isso/DriveInventory/$today-drives.fullreport
#/users/isso/DriveInventory
#Drive_inventory_DATE_TIME
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

Old filename:   $old_file
New filename:   $new_file

********************
"
diff -yi $old_file $new_file
echo "
********************
If nothing is between the stars then report found no discrepancies."