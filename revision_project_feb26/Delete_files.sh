#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"

Logpath="/var/logs/expense-new"
logfile=$(echo $0 | cut -d "." -f1)
Timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Logfilename="$Logpath/$logfile-$Timestamp.log"

echo "Script started executing at $Timestamp..$Y" &>>$Logfilename

if [$USER -ne 0]
then
echo -e "Root access is needed..$R" &>>$Logfilename
exit 1
fi

mkdir -p /var/logs/expense-new
$1=SDIR #passing as argument while execution


files_to_delete= $(find $SDIR -name *.log -mtime +14) &>>$Logfilename

if [ -n $files_to_delete ]
then 
echo -e "All set to delet files..$Y" &>>$Logfilename
while read -r deletefiles #deletfiles is variable name
do
echo -e "deleting files..$Y" &>>$Logfilename
rm -rf $deletefiles
done <<< $files_to_delete
echo -e "Files deleted successfully..$G" &>>$Logfilename

else
echo -e "No files older than 14 days  to delete...$G" &>>$Logfilename
fi
