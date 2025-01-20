#for i in {0..10}
#do
#echo $i
#done

#!/bin/bash

USER=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
logfolder="/var/log/shellscript-logs"
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
logfile=$(echo $0 | cut -d "." -f1)
Logfilename="$logfolder/$logfile-$timestamp.log"

Check() {
    if [ $1 -ne 0 ]
    then
    echo -e "Error:$R Root access is needed"
    exit 1
    fi
}


repeat() {
    if [ $1 -ne 0 ]
then
echo -e "$2..$R failure"
exit 1
else
echo -e "$2..$G success"
fi
}


echo "script started excecuting at $timestamp" &>>$Logfilename


Check $USER


for package in $@
do
dnf list installed $package &>>$Logfilename
if [ $? -ne 0 ]
then
dnf install $package -y &>>$Logfilename
repeat $? "Installing $package"
else
echo -e "$package already $G installed" 
fi
done

