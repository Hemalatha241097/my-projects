#!/bin/bash

USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
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
        echo -e "$2...$G SUCCESS $N"
    fi
}

echo "Script started running at $TIME_STAMP" &>>$LOGS_FILE_NAME

CHECK_USER


dnf module disable nodejs -y &>>$LOGS_FILE_NAME
VALIDATE $? "Disabling current version of nodejs"

dnf module enable nodejs:20 -y &>>$LOGS_FILE_NAME
VALIDATE $? "Enabling nodejs version 20"

dnf install nodejs -y &>>$LOGS_FILE_NAME
VALIDATE $? "Installing NodeJS"

id expense &>>$LOGS_FILE_NAME
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGS_FILE_NAME
    VALIDATE $? "Creating user expense"
else
    echo -e "expense user already existe..$Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGS_FILE_NAME
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading Backend"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGS_FILE_NAME
VALIDATE $? "Unzip backend"

npm install &>>$LOGS_FILE_NAME
VALIDATE $? "Installing dependencies"

cp /home/ec2-user/my-projects/expense/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>$LOGS_FILE_NAME
VALIDATE $? "Installing MySQL Client"

mysql -h mysql.hemadevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOGS_FILE_NAME
VALIDATE $? "setting up transactions schema and tables"

systemctl daemon-reload &>>$LOGS_FILE_NAME
VALIDATE $? "Daemon Reload"

systemctl enable backend &>>$LOGS_FILE_NAME
VALIDATE $? "Enabling backend"

systemctl restart backend &>>$LOGS_FILE_NAME
VALIDATE $? "Starting Backend"