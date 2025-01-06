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



dnf install mysql-server -y &>>$Logfilename
Repeat $? "Installing mysql" 


systemctl enable mysqld 
Repeat $? "Enabling sql server"

systemctl restart mysqld 
Repeat $? "Starting sql server"

mysql -h mysql.daws82.store -u root -pExpenseApp@1 -e 'show databases;' &>>$Logfilename

if [ $? -ne 0 ]
then
    echo "MySQL Root password not setup" &>>$Logfilename
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting Root Password"
else
    echo -e "MySQL Root password already setup ... $Y SKIPPING $N"
fi





