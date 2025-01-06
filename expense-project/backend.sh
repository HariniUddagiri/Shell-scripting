#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"



Logfolder="var/log/expense-logs"
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Logfile=$(echo $0 | cut -d "." -f1)
Logfilename="$Logfolder/$Logfile-$timestamp"

Check(){
    if [ $1 -ne 0 ]
    then
    echo -e "$R sudo access is needed"
    exit 1
    fi
}




Repeat (){
   
    if [ $1 -ne 0 ]
    then
    echo -e "$2..$R failure" 
    exit 1
    else
    echo -e "$2..$G success" 
    fi

}

mkdir -p $Logfolder &>>$Logfilename
echo "Script started executing at $timestamp" &>>$Logfilename



Check $USER

dnf module disable nodejs -y
Repeat $? "Disabling nodejs"

dnf module enable nodejs:20 -y
Repeat $? "Enabling nodejs"

dnf install nodejs -y
Repeat $? "Installing nodejs"

useradd expense

mkdir -p /app
Repeat $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
Repeat $? "Downloading backend code"

cd /app

unzip /tmp/backend.zip
Repeat $? "unzipping the code"

npm install
Repeat $? "Installing dependencies"

cp  /etc/systemd/system/backend.service