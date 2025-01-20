#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
echo "sudo access is needed"
exit 1
fi

dnf list installed mysql

if [ $? -ne 0 ]
then
echo "package is not available"
dnf install mysql -y
    if [ $? -ne 0 ]
    then
    echo " installing mysql...failure"
    exit 1
    else
    echo "installing mysql..success"
    fi
else
echo "package is already installed"
fi

dnf list installed git

if [ $? -ne 0 ]
then
    dnf install git -y
    if [ $? -ne 0 ]
    then
    echo "installing git...failure"
    else
    echo "installing git...success"
    fi
else
echo "git is already installed"
fi