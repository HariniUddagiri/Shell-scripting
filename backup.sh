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

if [ $# -lt 2 ]
then 
    Usage
fi


Usage(){
    echo -e "$R please pass the source & destination directories like : $Y sh backup.sh <Source_dir> <Destination_dir> <Days(optional)"
    exit 1
}

if [ ! -d $1  ]
then
echo -e "$R Source-directory does not exist"
exit 1
fi

if [ ! -d $2  ]
then
echo -e "$R Source-directory does not exist"
exit 1
fi


