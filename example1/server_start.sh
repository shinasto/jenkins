#! /bin/bash 
echo "###### Server script start"

C2C_DEPLOY_PATH="/var/server/"
C2C_JAR_PATH="/home/ubuntu/server/"
C2C_JAR_NAME="server-*.jar"

cd ${C2C_JAR_PATH}

C2C_JAR_FILE_NAME=`ls ${C2C_JAR_NAME}`
C2C_JAR_LATEST_NAME="server-latest.jar"
C2C_SERVICE_NAME="msa-server.service"
NOW=$(date +"%Y%m%d-%T")

echo $C2C_DEPLOY_PATH
echo $C2C_JAR_FILE_NAME
echo $NOW

echo "sudo systemctl stop ${C2C_SERVICE_NAME}"
sudo systemctl stop ${C2C_SERVICE_NAME}
echo -ne "${C2C_SERVICE_NAME} status : "
echo `systemctl is-active ${C2C_SERVICE_NAME}`

# wait 10 seconds until stopped
sleep 10

echo "Copy ${C2C_JAR_FILE_NAME} to ${C2C_JAR_LATEST_NAME}"
cp ${C2C_JAR_FILE_NAME} ${C2C_DEPLOY_PATH}${C2C_JAR_LATEST_NAME}
echo "Copy ${C2C_JAR_FILE_NAME} to ${C2C_JAR_FILE_NAME}.${NOW}"
cp ${C2C_JAR_FILE_NAME} ${C2C_DEPLOY_PATH}${C2C_JAR_FILE_NAME}.${NOW}

echo "sudo systemctl start ${C2C_SERVICE_NAME}"
sudo systemctl start ${C2C_SERVICE_NAME}

echo "################################################################### server.log"
timeout 25s tail -f ${C2C_DEPLOY_PATH}logs/server.log

systemctl is-active --quiet ${C2C_SERVICE_NAME}
if [ $? -eq 0 ]; then
    echo ">>>>> Service is running"
else
    echo ">>>>> Service running is failed - result=$?"
fi

echo "###### Server script end"
exit 0
