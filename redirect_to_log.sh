#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
logfolder="/var/log/shellscript-logs"
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
logfile=$(echo $0 | cut -d "." -f1)
Logfilename="$logfolder/$logfile-$timestamp.log"

echo "script started excecuting at $timestamp" &>>Logfilename
if [ $USER -ne 0 ]
then
echo -e "Error:$R Root access is needed"
exit 1
fi

dnf list installed mysql &>>Logfilename
if [ $? -ne 0 ]
then
dnf install mysql -y &>>Logfilename
repeat $? "Installing mysql"
else
echo -e "Mysql already $G installed" &>>Logfilename
fi

dnf list installed git &>>Logfilename
if [ $? -ne 0 ]
then
dnf install git -y
repeat $? "Installing git" 
else
echo -e "git already..$G installed" &>>Logfilename
fi

repeat() {
    if [ $1 -ne 0 ]
then
echo -e "$2..$R failure"
exit 1
else
echo -e "$2..$G success"
fi
}