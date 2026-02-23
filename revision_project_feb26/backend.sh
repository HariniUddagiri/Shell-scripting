#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)

Logpath="/var/logs/shellscript"
logfile=$(echo $0 cut -d "." -f1)
Timestamp=$(date +%Y-%m-%d-%H-%M-%S)

Logfilename="$Logpath/$logfile-$Timestamp".log

mkdir -p /var/logs/shellscript

Check(){
    if [$1 -ne 0]
    then
    echo "sudo access is needed...$R" &>>$Logfilename
    exit 1
    fi
}

Validate() {
    if [$1 -ne 0]
    then
    echo "$2 failed..$R" &>>$Logfilename
    exit 1
    else
    echo "$2 success..$G" &>>$Logfilename
    fi
}

echo "script starts executing at $Timestamp" &>>$Logfilename

Check $USER

dnf module disable nodejs -y
Validate $? "Disabling nodejs"

dnf module enable nodejs:20 -y
Validate $? "Enabling nodejs"

dnf install nodejs -y
Validate $? "Installing nodejs"

#For Idempotency, we are checking if uer already exists or not with simple command and then add user
id expense
if [$? -ne 0]
then
useradd expense
Validate $? "Adding user"
else 
echo "User already exists...SKIPPING..$Y" &>>$Logfilename
fi

mkdir -p /app #using -p for idempotency
Validate $? "directory creation"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
Validate $? "Downloading backend"

cd /app
rm -rf /aap/* # for idempotency, removing all files & sub directories if any exist

unzip /tmp/backend.zip
Validate $? "Unzipping backend code"

npm install
Validate $? "Installing dependencies"

cp /home/ec2-user/Shell-scripting/revision_project_feb26/backend.service /etc/systemd/system/backend.service

dnf install mysql -y
Validate $? "Installing MYSQL"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql 
Validate $? "LOADING transactions schema"

systemctl daemon-reload
Validate $? "Reload deamon"

systemctl enable backend
Validate $? "Enable backend"

systemctl restart backend
Validate $? "restart backend"






