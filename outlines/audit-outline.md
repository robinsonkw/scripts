# audit script outline
## Overview
The audit script intent is to automate the audit log review process by gathering pertinent information from
the relevant RHEL audit logs:
* secure
* meessages
* rkhunter output
Currently these logs are reviewed manually through searching the file.  The intent of this script is to
automate this process.
## Structure
Plan is to implement the following structure:
### Logs
1. Capture ISSO copy of logs (secure / messages ) by day.  Since the script will run everyday,
say like 0300 we can capture the previous days logs from the MMM dd entry and output that to
another file.
'''
$ grep -e '$yesterday' < secure > $yesterday-secure.file
$ grep -e '$yesterday' < messages < $yesterday-messages.file
'''
NOTE: These file paths will be replacec by absolute file paths based on the system.
1. Start capturing relevant audit data on the system
* number logons vs. number logoffs
* list of logons (sshd sessions)
* list of logoffs (sshd)
* list of logons su:session
* list of logoffs su
* new group created
* new user created/added
'''
echo "New user added"
grep -e 'useradd' < $yesterday-secure.file >> $yesterday-audit.report
echo "New group added"
grep -e 'useradd' < $yesterday-secure.file | grep -e '[n|N]ew [g|G]roup' >> $yesterday-audit.report
'''
Look for both new group and new user.
1. look for access denied
'''
echo "Any access denied in secure and messages logs..."
grep -i 'access denied' < $yesterday-secure.file >> $yesterday-audit.report
grep -i 'access denied' < $yesterday-messages.file >> $yesterday-audit.report
'''
NOTE: Want to add a count of each
1. look for any invalid in secure and messages
'''
echo "Any invalid attempts in secure and messages..."
grep -i 'invalid' < $yesterday-secure.file >> $yesterday-audit.report
grep -i 'invalid' < $yesterday-messages.file >> $yesterday-audit.report
'''
1. look for failed or failure
'''
echo "Any failed or failures..."
grep -e 'fail[ed|ure]' < $yesterday-secure.file >> $yesterday-audit.report
grep -e 'fail[ed|ure]' < $yesterday-messages.file >> $yesterday-audit.report
'''
1. look for warnings
'''
echo "Any warnings reported..."
grep -e 'warning' < $yesterday-secure.file >> $yesterday-audit.report
grep -e 'warning' < $yesterday-messages.file >> $yesterday-audit.report
'''
1. Look for any log space issues in messages...
'''
echo "Log space errors in messages log file..."
grep -i 'log space' < $yesterday-secure.file >> $yesterday-audit.report
grep -i 'log space' < $yesterday-messages.file >> $yesterday-audit.report
'''
1. Look for any USB issues..."
'''
echo "Any USB issues..."
grep -i 'usb' < $yesterday-secure.file >> $yesterday-audit.report
grep -i 'usb' < $yesterday-messages.files >> $yesterday-audit.report
'''

