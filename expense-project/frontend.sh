#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"



Log_folder="var/log/expense-logs"
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Log_file=$(echo $0 | cut -d "." -f1)
Log_filename="$Log_folder/$Log_file-$timestamp.log"

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


echo "Script started executing at $timestamp" &>>$Log_filename
mkdir -p $Log_folder

Check $USER

dnf install nginx -y &>>$Log_filename
Repeat $? "Installing nginx"

systemctl enable nginx &>>$Log_filename
Repeat $? "Enabling nginx"

systemctl start nginx &>>$Log_filename
Repeat $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$Log_filename
Repeat $? "Removing default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$Log_filename
Repeat $? "Downloading frontend content"

cd /usr/share/nginx/html &>>$Log_filename
Repeat $? "Extracting frontend content"

unzip /tmp/frontend.zip &>>$Log_filename
Repeat $? "unzipping the frontend code"

cp /home/ec2-user/Shell-scripting/expense-project/expense.conf /etc/nginx/default.d/expense.conf &>>$Log_filename

systemctl restart nginx &>>$Log_filename
Repeat $? "Restarting"


