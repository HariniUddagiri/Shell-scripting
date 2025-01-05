#!/bin/bash

USERID = $(id -u)

if [ $USERID -ne 0 ]
then 
echo " sudo access is needed"
if

#else 
#dnf list installed mysql