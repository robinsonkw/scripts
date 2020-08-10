#!/bin/bash
# Environment test script
#
MACOS=$(echo $OSTYPE | grep 'darwin')
UBUNTU=$(env | grep 'Ubuntu')
echo $MACOS
echo $UBUNTU

if [ ! $MACOS=="" ];
then
    echo "$MACOS means this is a Mac"
else
    echo "The Mac OS environment variable is null."
fi

exit

