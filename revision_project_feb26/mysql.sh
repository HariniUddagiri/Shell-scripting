#!/bin/bash

--check for root access first
R_USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"

Log_folder="var/logs/expense-new"
logfile=$(echo $0 | cut -d "." f1)
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
Logfilename="$Log_folder/$logfile-$timestamp.log"

mkdir -p var/logs/expense-new


CHECK (){
if [$1 -ne 0]
then
echo -e "sudo access is required..$R"
exit 1
fi
}

Validate (){
    if [$1 -ne 0]
    then
    echo -e "$2..$R failure"
    exit 1
    else
    echo -e "$2...$G sucess"
    fi
}

CHECK $R_USER

echo -e "script starting at $timestamp" &>>$Logfilename

dnf install mysql-server -y
Validate $? "Inastlling mysql" &>>$Logfilename

systemctl enable mysqld
Validate $? "Enabling mysqld" &>>$Logfilename

systemctl start mysqld
Validate $? "starting mysqld" &>>$Logfilename


mysql -h mysq.daws82s.store -u root -pExpenseApp@1 -e 'show databases;'

if [$? -ne 0]
then
    echo -e "Password is not setup..$Y" &>>$Logfilename
    mysql_secure_installation --set-root-pass ExpenseApp@1
    Validate $? "Setting password" &>>$Logfilename
else
    echo "Password is already setup..$Y" &>>$Logfilename
fi
