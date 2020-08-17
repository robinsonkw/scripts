#!/bin/bash
echo "
     ###########################
     #  openEMR Patch download #
     ###########################

This will download the latest version of 
the openEMR patch for the selected version.
"
WEB_PATH='https://www.open-emr.org/patch/'
VERSION='5-0-2'
PATCH='3'

printf "Enter file path to place file: "
read PATH
printf "This will download openEMR version $VERSION
with patch $PATCH. Ok? [yes/No]  "
read confirm

DOWNLOAD=${WEB_PATH}${VERSION}'-Patch-'$PATCH'.zip'
LOCATION=${PATH}/${VERSION}'-Patch-'$PATCH'.zip'

echo $DOWNLOAD
echo $LOCTION
exit
case $confirm in
    y*|Y*|"") curl $DOWNLOAD > $LOCATION ;;
    n*|N*) echo "Patch download skipped."; return ;;
    *) echo "Invalid choice. Patch download skipped."; return ;;
esac

# https://www.open-emr.org/patch/5-0-2-Patch-2.zip

