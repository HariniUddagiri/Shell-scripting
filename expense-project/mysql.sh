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
    else
    exit 1
    echo -e "$2..$G success" 
    fi

}

mkdir -p $Logfolder &>>$Logfilename
echo "Script started executing at $timestamp" &>>$Logfilename



Check $USER


dnf list installed mysql-server
if [ $? -ne 0 ]
then
dnf install mysql-server -y &>>$Logfilename
Repeat $? "Installing mysql" 
else
echo -e "$Y mysql $G already installed" 
fi

systemctl enable mysqld &>>$Logfilename
Repeat $? "Enabling sql server"

systemctl start mysqld &>>$Logfilename
Repeat $? "Starting sql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$Logfilename
Repeat $? "Setting password"



