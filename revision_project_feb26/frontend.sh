#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"

logpath="/var/logs/shell-script"
logfile=$(echo $0 | cut -d "." -f1)
Timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Logfilename="$logpath/$logfile-$Timestamp.log"

mkdir -p /var/logs/shell-script

USER=$(id -u)

CHECK(){
    if [$1 -ne 0]
    then
    echo "sudo access is needed..$R" &>>Logfilename
    exit 1
    fi
}

Validate(){
    if [$1 -ne 0]
    then
    echo "$2..failed..$R" &>>Logfilename
    else
    echo "$2..success..$G" &>>Logfilename
    fi
    }

echo "script starting at $Timestamp" &>>Logfilename

CHECK $USER

dnf install nginx -y
Validate $? "Installing nginx"

systemctl enable nginx
Validate $? "Enabling nginx"

systemctl start nginx
Validate $? "Starting nginx"

rm -rf /usr/share/nginx/html/*
Validate $? "Removing existing code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
Validate $? "Downloading code"

cd /usr/share/nginx/html
Validate $? "Moving to html directory"

unzip /tmp/frontend.zip
Validate $? "Unzipping code"

cp /home/ec2-user/Shell-scripting/revision_project_feb26/expense.conf /etc/nginx/default.d/expense.conf

systemctl restart nginx
Validate $? "Restarting server"




