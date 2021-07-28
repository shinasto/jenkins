#! /bin/bash

SOURCE="${BASH_SOURCE[0]}"
PEM="/home/ubuntu/.ssh/keys/shinasto.pem"
CLOUD_SERVER_URL=$1
C2C_JAR_NAME="test-server-*.jar"
C2C_JAR_FILE_NAME=`ls ${C2C_JAR_NAME}`
C2C_SCRIPT_FILE="test-server_script.sh"

echo "Source path=${SOURCE}"
echo "PEM path=${PEM}"
echo "C2C Server URL=${CLOUD_SERVER_URL}"

echo "#### Delete test-server file"
ssh -i ${PEM} ubuntu@${CLOUD_SERVER_URL} rm ./test-server/${C2C_JAR_NAME}

echo "#### COPY test-server file to C2C server"
scp -i ${PEM} ./${C2C_JAR_FILE_NAME} ubuntu@${CLOUD_SERVER_URL}:~/test-server
if [ $? -ne 0 ]; then 
	echo "Failed copy file"
	exit 100
fi

echo "#### Run deploy script from ssh [to C2C]"
ssh -i ${PEM} ubuntu@${CLOUD_SERVER_URL} sh ./test-server/${C2C_SCRIPT_FILE}
if [ $? -ne 0 ]; then
	"Failed run deploy script"
        exit 100
fi

echo "#### end of test-server_deploy.sh" 
exit 0
