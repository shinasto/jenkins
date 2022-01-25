#! /bin/bash

SOURCE="${BASH_SOURCE[0]}"
PEM="/home/ubuntu/.ssh/keys/test.pem"
WORK_DIR="/home/ubuntu/server"
C2C_SERVER_URL=$1
C2C_JAR_NAME="server-*.jar"

cd $WORK_DIR/

C2C_JAR_FILE_NAME=`ls ${C2C_JAR_NAME} | tail -1`
C2C_SCRIPT_FILE="server_start.sh"

echo "Source file=${C2C_JAR_FILE_NAME}"
echo "Source path=${SOURCE}"
echo "PEM path=${PEM}"
echo "C2C Server URL=${C2C_SERVER_URL}"

echo "#### Delete server file"
ssh -i ${PEM} ubuntu@${C2C_SERVER_URL} rm ./server/${C2C_JAR_NAME}

echo "#### COPY binary file to server"
scp -i ${PEM} ${WORK_DIR}/${C2C_JAR_FILE_NAME} ubuntu@${C2C_SERVER_URL}:~/server
if [ $? -ne 0 ]; then
        echo "Failed copy file"
        exit 100
fi

echo "#### Run deploy script from ssh [to C2C]"
ssh -i ${PEM} ubuntu@${C2C_SERVER_URL} sh ./server/${C2C_SCRIPT_FILE}
if [ $? -ne 0 ]; then
        "Failed run deploy script"
        exit 100
fi

echo "#### end of server_deploy.sh" 
exit 0
