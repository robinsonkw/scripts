#!/bin/bash
echo "
     ###########################
     #  openEMR Patch download #
     ###########################

This will download the latest version of 
the openEMR patch for the selected version.
"
WEB_PATH='https://www.open-emr.org/patch/';
VERSION='5-0-2';
PATCH='3';
read -n "Enter file path to place file: " PATH

read -n "This will download openEMR version $VERSION
with patch $PATCH. Ok? [yes/No]" confirm

case
exit    
esac
# https://www.open-emr.org/patch/5-0-2-Patch-2.zip

