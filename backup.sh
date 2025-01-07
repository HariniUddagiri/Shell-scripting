#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Log_folder="var/log/Shell-scripting"
Log_file=$(echo $0 | cut -d "." -f1)
Timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Log_file_name="$Log_folder/$Log_file-$Timestamp.log"



#SDIR="/home/ec2-user/app-logs"
#DDIR="/home/ec2-user/archive"

SDIR=$1
DDIR=$2
Days=${3:-14}



Usage(){
    echo -e "$R USAGE:: $N sh 18-backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
    #echo -e "$R USAGE:: $N backup <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
    exit 1
}

mkdir -p var/log/Shell-scripting

if [ $# -lt 2 ]
then 
    Usage
fi


if [ ! -d "$SDIR"  ]
then
echo -e "$R Source-directory does not exist"
exit 1
fi

if [ ! -d "$DDIR" ]
then
echo -e "$R Destination-directory does not exist"
exit 1
fi



echo "Script started excecuting at $Timestamp"
Files=$(find $SDIR -name "*.log" -mtime +$Days)

if [ -n "$Files" ]
then
echo "Files are: $Files"
Zip_file="$DDIR/app-logs-$Timestamp.zip"
find $SDIR -name "*.log" -mtime +$Days | zip -@ "$Zip_file"
if [ -f "$Zip_file" ]
then 
echo -e "$G Successfully created zip file"
while read -r filepath
do
    echo "Deleting files after zipping"
    rm -rf $filepath
    echo "Deleted file: $filepath"
done <<< $Files
else
echo -e "$R Error:: $N Failed to create ZIP file "
exit 1
fi
else
echo "No files found older than $Days"
fi



