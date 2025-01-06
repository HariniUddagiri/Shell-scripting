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


mkdir -p $Logfolder
echo "Script started executing at $timestamp" &>>$Logfilename

Check $USER

dnf install nginx -y &>>$Logfilename
Repeat $? "Installing nginx"

systemctl enable nginx &>>$Logfilename
Repeat $? "Enabling nginx"

systemctl start nginx &>>$Logfilename
Repeat $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$Logfilename
VALIDATE $? "Removing existing version of code"


curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$Logfilename
Repeat $? "Downloading frontend content"

cd /usr/share/nginx/html &>>$Logfilename
Repeat $? "Extracting frontend content"

unzip /tmp/frontend.zip &>>$Logfilename
Repeat $? "unzipping the frontend code"

cp /home/ec2-user/Shell-scripting/expense-project/expense.conf /etc/nginx/default.d/expense.conf &>>$Logfilename

systemctl restart nginx &>>$Logfilename
Repeat $? "Restarting"
