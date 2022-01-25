* ci_s3_deploy.sh
  * 빌드 바이너리를 s3 저장소에 배포 스크립트
  * Jenkins CI Job Execute sehll에 작성
* cd_pipeline.groovy
  * 배포 Job 파이프라인
  * SERVER_LIST 서버를 대상으로 배포 작업 수행 (Rolling deployment)
* server_download.sh
  * s3로 부터 특정 버전 서버 바이너리를 다운로드 수행하는 스크립트
* check_file.sh
  * 바이너리 다운로드 여부 확인 스크립트 
* server_deploy.sh
  * 서버 instance에서 바이너리 배포 및 실행 요청 스크립트
* server_start.sh
  * 서버 재시작 스크립트
