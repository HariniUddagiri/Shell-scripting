#!/bin/bash

USER=$(id -u)

if [ $USER -ne 0 ]
then
echo "Root access is needed"
exit 1
fi

dnf list installed mysql
if [ $? -ne 0 ]
then
dnf install mysql -y
repeat $? "Installing mysql"
else
echo "Mysql already installed"
fi

dnf list installed git
if [ $? -ne 0 ]
then
dnf install git -y
repeat $? "Installing git"
else
echo "git already installed"
fi

repeat() {
    if [ $1 -ne 0 ]
then
echo "$2..failure"
exit 1
else
echo "$2..success"
fi
}