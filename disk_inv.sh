#!/usr/bin/env bash
today=$(date +%Y%m%d)
exec > ~/NetApp/$today-disk.inv
#/users/isso/NetApp
#Netapp.disks.serial.log.date
this_month=$(date +%b%Y)
last_month=`date --date "last Month" "+%b%Y"`
filepath='/home/ec2-user'
location=$filepath'/'${this_month}'_CremRep'
filename='disk.inventory.now'
datetime=$(date +%H:%M:%S)
current_file=$(ls -tr | tail -n 1)
this_thursday=`date --date "Thursday" "+%m_%d_%Y"`
last_thursday=`date --date "last Thursday" "+%m_%d_%Y"`
old_file=`find $location -name ${filename}_${last_thursday}"*"`
new_file=`find $location -name ${filename}_${this_thursday}"*"`

echo "
Script compares the disk report for idmgr from Thursday to Thursday to detect 
changes.  This script was last run on $today at $datetime.

If nothing follows this section then the report found no discrepancies.
*****************************************************************************
Compare $old_file
with $new_file

"
diff -i $old_file $new_file

