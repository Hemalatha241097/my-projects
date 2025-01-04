#!/bin/bash

USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FOLDER="/var/log/shellscript-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
LOGS_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIME_STAMP.log"

echo "Script started running at $TIME_STAMP"

CHECK_USER

CHECK_USER(){

    if [ $USER_ID -ne 0]
        then
        echo "ERROR:: You need to be sudo user to run the script"
        exit 1
    else

    fi   
}