1 #!bin/bash
2
3 rkhunter --update --quiet
4 rkhunter --cronjob --quiet
5
6 today=$(date +%Y%m%d)
7 mv /var/log/rkhunter/rkhunter.log /var/log/rkhunter/rkhunter-$today
