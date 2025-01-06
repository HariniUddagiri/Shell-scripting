#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"



Logfolder="var/log/expense-logs"
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Logfile=$(echo $0 | cut -d "." -f1)
Logfilename="$Logfolder/$Logfile-$timestamp.log"

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

dnf module disable nodejs -y &>>$Logfilename
Repeat $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>$Logfilename
Repeat $? "Enabling nodejs"

dnf install nodejs -y &>>$Logfilename
Repeat $? "Installing nodejs"

useradd expense

mkdir -p /app &>>$Logfilename
Repeat $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$Logfilename
Repeat $? "Downloading backend code"

cd /app

unzip /tmp/backend.zip &>>$Logfilename
Repeat $? "unzipping the code"

npm install &>>$Logfilename
Repeat $? "Installing dependencies"

cp /Shell-scripting/expense-project/backend.service /etc/systemd/system/backend.service &>>$Logfilename

systemctl daemon-reload &>>$Logfilename
Repeat $? "Reload daemon"

systemctl start backend &>>$Logfilename
Repeat $? "starting the backend"

systemctl enable backend &>>$Logfilename
Repeat $? "Enabling the backend"

dnf install mysql -y &>>$Logfilename
Repeat $? "Installing Mysql"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$Logfilename
Repeat $? "Setting up the transactions schema and tables"

systemctl restart backend &>>$Logfilename
Repeat $? "Restarting backend"
