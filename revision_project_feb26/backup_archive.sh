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
$2=DDIR
Days={3:-14} #if we don't pass no.of days as argumet, it will pick 14 by default

if [ $# -lt 2 ]
then
echo -e "All required arguments  are not available..$R" &>>$Logfilename
exit 1
fi

if [ ! -d "$SDIR" ]
then
echo -e "Source Directory does not exist..$R" &>>$Logfilename
exit 1
fi

if [ ! -d "$DDIR" ]
then
echo -e "Destination Directory does not exist..$R" &>>$Logfilename
exit 1
fi

Files=$(find $SDIR -name "*.log" -mtime +$Days)
if [ -n "$Files"]
then
echo -e "Files available to proceed with zip:$Files" &>>$Logfilename
ZIP_FILE="$DDIR/app-logs-$Timestamp.zip"
find $SDIR -name "*.log" -mtime +$Days | zip -@ "$ZIP_FILE"
    if [ -f "$ZIP_FILE"]
    then
    echo -e "$G Successfully created zip file" &>>$Logfilename
    while read -r filestodelete
    do
    echo "Deleting files after zipping" &>>$Logfilename
    rm -rf $filestodelete
    echo "Deleted file: $filestodelete" &>>$Logfilename
    done<<<$Files
    else
    echo -e "$R Error:: $N Failed to create ZIP file" &>>$Logfilename
    exit 1
    fi
else
echo -e "Files not available older than $Days to zip..$Y" &>>$Logfilename
fi




