#!/bin/bash
# plan
# enter domain name
# script pings for IP, gets regex match on IP, puts domain name and IP address in hosts file
exec > hosts.reverse

for h in $(cat whitelist.file); do
  printf "$h = %s\\n" $(dig +short "$h")
done
