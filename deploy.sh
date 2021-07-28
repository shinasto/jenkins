#! /bin/bash 
echo "###### Server deploy"

EC_APP_NAME="test-server"
EC_IMAGE_TAG=$1
EC_IMAGE_NAME_TAG="${EC_APP_NAME}:${EC_IMAGE_TAG}"
DOCKER_HUB_ACCOUNT="shinasto"

echo "App Name=${EC_APP_NAME}"
echo "Docker Image=${EC_IMAGE_NAME_TAG}"

CONTAINER_ID=`sudo docker ps -aqf "name=${EC_APP_NAME}"`

echo "Container ID=${CONTAINER_ID}"

sudo docker pull ${DOCKER_HUB_ACCOUNT}/${EC_IMAGE_NAME_TAG}
if [ $? -eq 0 ]; then
    echo ">>>>> Docker pull is success"
else
    echo ">>>>> Docker pull is failed - result=$?"
    exit 2
fi

sudo docker rm -f ${CONTAINER_ID}
sudo docker run -d -u root -p 30005:30005 --name=test-server --restart=always -v /home/ubuntu/test-server/log:/test-server --net=host --log-driver=none ${DOCKER_HUB_ACCOUNT}/${EC_IMAGE_NAME_TAG}

echo "################################################################### test-server.log"
timeout 15s tail -f /data/test-server/log/test-server.log
echo "###### ht-event-control deploy end"
exit 0
