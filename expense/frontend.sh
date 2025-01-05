#!/bin/bash

USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$($0 | cut -d "." -f1 )
LOGS_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIME_STAMP.log"

echo "Script started running at $TIME_STAMP" &>>$LOGS_FILE_NAME

CHECK_USER

CHECK_USER(){
    if [ $USER_ID -ne 0 ]
    then
    echo "ERROR :: You must be a root user to run this script"
    exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
    echo -e "$2...$R FAILURE $N"
    else
    echo -e "$2...$R SUCCESS $N"
    fi
}
