#! /bin/bash

DEPLOY_TYPE=release
BUCKET='binary-update'
JAR_NAME="$(basename ./target/server-*.jar)"

echo "    > AWS S3 MOVE Backup file"
aws s3 mv s3://${BUCKET}/${DEPLOY_TYPE}/server/msa/ s3://${BUCKET}/${DEPLOY_TYPE}/server/msa/backup/ --recursive --exclude "backup/*"


echo "    > AWS S3 업로드 : ${DEPLOY_TYPE}"
aws s3 cp ./target/${JAR_NAME} s3://${BUCKET}/${DEPLOY_TYPE}/server/msa/${JAR_NAME} --region ap-northeast-2
echo "    > AWS S3 업로드 완료"
