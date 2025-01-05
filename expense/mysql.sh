#!/bin/bash

USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
LOGS_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIME_STAMP.log"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 is $R FAILURE $N"
    else
        echo -e "$2 is $G SUCCESS $N"
    fi
}

CHECK_USER(){
    if [ $USER_ID -ne 0 ]
    then
        echo "ERROR:: You need to be sudo user to run the script"
        exit 1
    fi   
}

echo "Script started running at $TIME_STAMP" &>>$LOGS_FILE_NAME

CHECK_USER

dnf install mysql-server -y &>>LOGS_FILE_NAME
VALIDATE $? "Installing MySQL"

systemctl enable mysqld &>>LOGS_FILE_NAME
VALIDATE $? "Enabling mysqld service"

systemctl start mysqld &>>LOGS_FILE_NAME
VALIDATE $? "Starting mysqld service"

mysql -h mysql.hemadevops.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOGS_FILE_NAME

mysql_secure_installation --set-root-pass ExpenseApp@1



