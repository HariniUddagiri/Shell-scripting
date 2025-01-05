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
    else
    echo "installing mysql..success"
    fi
else
echo "package is already installed"
fi

#else 
#dnf list installed mysql