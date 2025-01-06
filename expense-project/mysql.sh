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
    dnf install $package -y &>>$Logfilename
    if [ $1 -ne 0 ]
    then
    echo -e "$2..$R failure" 
    else
    echo -e "$2..$G success" 
    fi

}

mkdir -p $Logfolder &>>$Logfilename
echo "Script started executing at $timestamp" &>>$Logfilename



Check $USER


for package in $@
do
dnf list installed $package &>>$Logfilename
if [ $? -ne 0 ]
then
Repeat $? "Installing $package" 
else
echo -e "$package $G already installed" 
fi
done
