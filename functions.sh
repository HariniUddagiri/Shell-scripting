#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"

if [ $USER -ne 0 ]
then
echo "Error:$R Root access is needed"
exit 1
fi

dnf list installed mysql
if [ $? -ne 0 ]
then
dnf install mysql -y
repeat $? "$Y Installing mysql"
else
echo "$G Mysql already installed"
fi

dnf list installed git
if [ $? -ne 0 ]
then
dnf install git -y
repeat $? "$Y Installing git"
else
echo "$G git already installed"
fi

repeat() {
    if [ $1 -ne 0 ]
then
echo "$2..$R failure"
exit 1
else
echo "$2..$G success"
fi
}