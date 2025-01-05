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

echo "Script started running at $TIME_STAMP" &>>$LOGS_FILE_NAME

CHECK_USER

dnf install nginx -y  &>>$LOG$_FILE_NAME
VALIDATE $? "Installing Nginx Server"

systemctl enable nginx &>>$LOGS_FILE_NAME
VALIDATE $? "Enabling Nginx server"

systemctl start nginx &>>$LOGS_FILE_NAME
VALIDATE $? "Starting Nginx Server"

rm -rf /usr/share/nginx/html/* &>>$LOGS_FILE_NAME
VALIDATE $? "Removing existing version of code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading Latest code"

cd /usr/share/nginx/html
VALIDATE $? "Moving to HTML directory"

unzip /tmp/frontend.zip &>>$LOGS_FILE_NAME
VALIDATE $? "unzipping the frontend code"

cp /home/ec2-user/my-projects/expense/expense.conf /etc/nginx/default.d/
VALIDATE $? "Copied expense config"

systemctl restart nginx &>>$LOG_FILE_NAME
VALIDATE $? "Restarting nginx"
