#!/bin/bash

Log_folder="var/log/Shell-scripting"
Log_file=$(echo $0 | cut -d "." -f1)
Timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Log_file_name="$Log_folder/$Log_file-$Timestamp.log"

mkdir -p "$Log_folder"

echo "Script started excecuting at $Timestamp"

#SDIR="/home/ec2-user/app-logs"
#DDIR="/home/ec2-user/archive"

SDIR=$1
DDIR=$2
Days={$3:-14}



Usage(){
    echo -e "$R USAGE:: $N sh 18-backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
    #echo -e "$R USAGE:: $N backup <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
    exit 1
}

if [ $# -lt 2 ]
then 
    Usage
fi


if [ ! -d $1  ]
then
echo -e "$R Source-directory does not exist"
exit 1
fi

if [ ! -d $2  ]
then
echo -e "$R Destination-directory does not exist"
exit 1
fi

Files=$(find $1 -name "*log" -mtime +14)

if [ ! -n $Files ]
then
echo "No files to delete"
exit 1
else
echo "Files to delete : $Files"
fi



