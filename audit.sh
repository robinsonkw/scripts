#!/bin/sh

## variables##
FILE_PATH='/var/log/audit'
FILE_NAME='auditscript.log'
today=$(date +%Y%m%d)
yesterday=$(date --date "Yesterday" +%Y%h%m)
WEEK_END=$(date --date "last Sudnay" +%Y%m%d)
log_day=$(date +%m/%d/%Y)
TS='-ts yesterday'
TE='-te '$log_day' 00:00:00'
OPEN_COUNT=`grep -c "session opened" /var/log/archives/secure-$WEEK_END`
CLOSED_COUNT=`grep -c "session closed" /var/log/archives/secure-$WEEK_END`
SESSIONS=`grep -e "session opened" -e "session closed" -i /var/log/archives/secure-$WEEK_END`
LAST=`last -10`
SUMMARY=`aureport $TS $TE --summary -i`
AU_REPORT=`aureport $TS $TE -au -i`
LOGIN_SUCCESS=`aureport $TS $TE -l --success`
LOGIN_FAILED=`aureport $TS $TE -l --failed`
KEY_REPORT=`aureport $TS $TE -k`
AUTH_SUCCESS=`aureport $TS $TE -au -i --success`
AUTH_FAILED=`aureport $TS $TE -au -i --failed`
SUMMARY_SUCCESS=`aureport -l --success --summary -i`
SUMMARY_FAILED=`aureport -l --failed --summary -i`
AUREPORT=`aureport $TS $TE`

## OUTPUT
mv ${FILE_PATH}/${FILE_NAME} ${FILE_PATH}/${FILE_NAME}.last
exec > ${FILE_PATH}/${FILE_NAME}

echo "
$LAST
#$SUMMARY
#$SUMMARY_SUCCESS
$LOGIN_SUCCESS
$SUMMARY_FAILED
$LOGIN_FAILED
$AUTH_SUCCESS
$AUTH_FAILED
"
aureport $TS $TE -k
aureport $TS $TE -a
aureport $TS $TE -c
aureport $TS $TE -cr
aureport $TS $TE -e
aureport $TS $TE -f
aureport $TS $TE -h
aureport $TS $TE -m
aureport $TS $TE -ma
aureport $TS $TE -n
aureport $TS $TE -p
aureport $TS $TE -r
aureport $TS $TE -s
aureport $TS $TE -u
aureport $TS $TE -x

cp /var/log/audit/auditscript.log /var/log/audit/auditscript.log.last
mv /var/log/audit/auditscript.log /var/log/audit/audit-$today
add fine 'useradd'
