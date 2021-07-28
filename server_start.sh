#! /bin/bash 
echo "###### Test Server script start"

JAR_DEPLOY_PATH="/hdtel/c2c/"
TEST_JAR_PATH="/home/ubuntu/test-server/"
TEST_JAR_NAME="c2cserver-*.jar"

cd ${TEST_JAR_PATH}

TEST_JAR_FILE_NAME=`ls ${TEST_JAR_NAME}`
TEST_JAR_LATEST_NAME="c2cserver-latest.jar"
TEST_SERVICE_NAME="test-server.service"
NOW=$(date +"%Y%m%d-%T")

echo $JAR_DEPLOY_PATH
echo $TEST_JAR_FILE_NAME
echo $NOW

echo "sudo systemctl stop ${TEST_SERVICE_NAME}"
sudo systemctl stop ${TEST_SERVICE_NAME}
echo -ne "${TEST_SERVICE_NAME} status : "
echo `systemctl is-active ${TEST_SERVICE_NAME}`

echo "Copy ${TEST_JAR_FILE_NAME} to ${TEST_JAR_LATEST_NAME}"
cp ${TEST_JAR_FILE_NAME} ${JAR_DEPLOY_PATH}${TEST_JAR_LATEST_NAME}
echo "Copy ${TEST_JAR_FILE_NAME} to ${TEST_JAR_FILE_NAME}.${NOW}"
cp ${TEST_JAR_FILE_NAME} ${JAR_DEPLOY_PATH}${TEST_JAR_FILE_NAME}.${NOW}

echo "sudo systemctl start ${TEST_SERVICE_NAME}"
sudo systemctl start ${TEST_SERVICE_NAME}

echo "################################################################### test-server.log"
timeout 25s tail -f ${JAR_DEPLOY_PATH}logs/test_server.log

systemctl is-active --quiet ${TEST_SERVICE_NAME}
if [ $? -eq 0 ]; then
    echo ">>>>> Test Service is running"
else
    echo ">>>>> Test Service running is failed - result=$?"
fi

echo "###### Test Server script end"
exit 0
