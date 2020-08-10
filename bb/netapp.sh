#!/usr/bin/env bash
#/users/isso/NetApp
#Netapp.disks.serial.log.date
today=$(date +%Y%m%d)
exec > /users/isso/NetApp/$today-netapp

location='/users/isso/NetApp'
filename='netapp.disks.serial.log'
datetime=$(date +%H:%M:%S)
current_file=$(ls -tr | tail -n 1)
befpre=date --date "Tuesday" "+%m_%d_%Y"
after=date --date "Thursday" "+%m_%d_%Y"

echo "
Script compares the disk report for NetApp from Thursday to Thursday to detect changes.  This script was last run on $today at $datetime.

If nothing follows this section then the report found no discrepancies.
*****************************************************************************
"
diff -uwi $location/$filename.$before $location/$filename.$after
