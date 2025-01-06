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
    if [ $USER -ne 0 ]
    then
    echo "sudo access is needed"
    exit 1
    fi
}




Repeat (){
    dnf install mysql
    if [ $1 -ne 0 ]
    then
    echo "$2..failure"
    else
    echo "$2..success"
    fi

}

echo "Script started executing at $timestamp"

Check


for package in $@
do
dnf list installed $package
if [ $? -ne 0 ]
then
Repeat $? "Inatalling $package"
else
echo "$package already installed"
fi
done
