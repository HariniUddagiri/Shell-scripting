#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
logfolder="/var/log/shellscript-logs"
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
logfile=$(echo $0 | cut -d "." -f1)
Logfilename="$logfolder/$logfile-$timestamp.log"

SOURCE_DIR="/home/ec2-user/Shell-scripting/expense-project/var/log/expense-logs"

mkdir -p $logfolder

echo "script started excecuting at $timestamp" &>>$Logfilename
if [ $USER -ne 0 ]
then
echo -e "Error:$R Root access is needed"
exit 1
fi



files_to_delete=$(find $SOURCE_DIR -name "*.log" -mtime +5)
echo "Files to be deleted: $files_to_delete"

while read -r filepath # here filepath is the variable name, you can give any name
do
    echo "Deleting file: $filepath" &>>$Logfilename
    rm -rf $filepath
    echo "Deleted file: $filepath"
done <<< $files_to_delete