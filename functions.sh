#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"

if [ $USER -ne 0 ]
then
echo -e "Error:$R Root access is needed"
exit 1
fi

dnf list installed mysql
if [ $? -ne 0 ]
then
dnf install mysql -y
repeat $? "Installing mysql"
else
echo -e "$G Mysql already installed"
fi

dnf list installed git
if [ $? -ne 0 ]
then
dnf install git -y
repeat $? "Installing git"
else
echo -e "git already..$G installed"
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