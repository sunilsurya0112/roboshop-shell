#!/bin/bash


ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
       if [ $1 -ne 0 ]
        then 
                 echo -e "$2 ..is $R FAILED$N"
        else 
                 echo -e "$2  .. is $G SUCCESS$N"
       fi 


}

if [ $ID -ne 0 ]
then 
    echo -e " $R you are not root user$N"
    exit 1

else
    echo -e "$N you are $G root user$N"
fi

cp mongo.repo /etc/yum.repos.d/ &>> $LOGFILE

VALIDATE $? "copied mongodb repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Resatrting MongoDB"