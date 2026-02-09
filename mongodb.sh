#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script/$0.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "$R please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
   if [ $1 -ne 0 ];  then
      echo -e "$2 is :$R failure $N" | tee -a $LOGS_FILE
      exit 1
   else
      echo -e "$2 : $G pass $N"  | tee -a $LOGS_FILE
   fi

}

cp mongo.repo /etc/yum/repos.d/mongo.repo
VALIDATE $? "copying Mongo repo"

dnf install mongodb-org -y 
VALIDATE $? "Installing Mongodb"

systemctl enable mongod 
VALIDATE $? "Ebanling Mongodb server"

systemctl start mongod 
VALIDATE $? "Starting Mongodb server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod
VALIDATE $? "Restarting Mongodb"
