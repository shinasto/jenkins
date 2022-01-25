
#!/bin/sh

WORK_DIR="/home/ubuntu/server"

download_file_latest() {
  cd $WORK_DIR/
  echo "latest file download starting....."

  rm -rf $WORK_DIR/server-*.jar

  file_name=$(aws s3 ls s3://server-update/release/server/msa/ | awk '{ if($3 >0) print $4}')

  wget -np http://aaa.cloudfront.net/release/server/msa/$file_name

  if [ -f "$WORK_DIR/$file_name" ]; then
      echo "download file complete. file_name=$file_name"
  else
      echo "Error: file download failed. file_name=$file_name"
      exit 1
  fi
}

download_file_by_version() {
  cd $WORK_DIR/
  echo "specific file download starting....."
  file_name="server-$1.jar"

  rm -rf $WORK_DIR/server-*.jar

  wget -np http://aaa.cloudfront.net/release/server/msa/backup/$file_name

  if [ -f "$WORK_DIR/$file_name" ]; then
      echo "download file complete. file_name=$file_name"
  else
      echo "Error: file download failed. file_name=$file_name"
      exit -1
  fi
}

if [ $# -lt 1 ]
then
        echo "Usage : $0 [latest|{version}]"
        exit
fi

case "$1" in
    latest)
        download_file_latest
        ;;
    *)
        download_file_by_version $1
        ;;
esac
