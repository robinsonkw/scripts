#!/bin/bash

file=~/speedtest.file
current_date=$(date)

echo "" >> $file
echo $current_date >> $file
speedtest-cli >> $file
