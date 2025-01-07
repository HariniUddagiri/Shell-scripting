#!/bin/bash

Disk_space=$(df -hT | grep 'xfs')
Disk_threshold=5

while read -r line
do
partition=$(echo $line | awk -F " " '{print $NF}')
Usage=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1)
if [ $Usage -ge $Disk_threshold ]
then
msg+="High disk usage on partition:$partition, Usage:$Usage"\n
fi
done <<< $Disk_space

echo $msg

echo "High disk usage alert $(date)" | mutt -s "msg" hunny11147@gmail.com