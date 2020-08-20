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
1. Capture ISSO copy of logs (secure / messages ) by day
1. 
