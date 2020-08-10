#!/bin/bash
# Environment test script
#
MACOS=$(echo $OSTYPE | grep 'darwin')
UBUNTU=$(env | grep 'Ubuntu')
echo $MACOS
echo $UBUNTU

if test -z "$MACOS"
then
    echo "empty"
else
    echo "$MACOS means this is a Mac"
fi

exit

