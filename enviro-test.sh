#!/bin/bash
# Environment test script
#
MACOS=$(echo $OSTYPE | grep 'darwin')
UBUNTU=$(env | grep 'Ubuntu')
echo $MACOS
echo $UBUNTU
exit

