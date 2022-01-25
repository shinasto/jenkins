def ssh_publisher(SERVER_URL) { 
    sshPublisher( 
        continueOnError: false, 
        failOnError: true, 
        publishers:[ 
            sshPublisherDesc( 
                configName: "C2C", 
                verbose: true, 
                transfers: [ 
                    // (5.1) Copy script files 
                    // sshTransfer( 
                    //     sourceFiles: "deploy/develop/script/*.sh", 
                    //     removePrefix: "deploy/develop/script", 
                    //     remoteDirectory: "build/script" 
                    // ), 
                    // (5.2) Copy build files 
                    // sshTransfer( 
                    //     sourceFiles: "build/libs/*.jar", 
                    //     removePrefix: "build/libs", 
                    //     remoteDirectory: "/build/lib", 
                    //     // Absolute path. 
                    //     execCommand: "sh /home/build/script/deploy_server.sh" ), 
                    sshTransfer( 
                        // Absolute path.
                        execCommand: "/home/ubuntu/server/server_deploy.sh ${SERVER_URL}"
                    )
                ] 
            ) 
        ] 
    ) 
}

def downloadFile(SERVER_VERSION) { 
    sshPublisher( 
        continueOnError: false, 
        failOnError: true, 
        publishers:[ 
            sshPublisherDesc( 
                configName: "C2C", 
                verbose: true, 
                transfers: [ 
                    sshTransfer( 
                        execCommand: "sh ./server/server_download.sh ${SERVER_VERSION}"
                    )
                ] 
            ) 
        ] 
    ) 
}


# Job 매개변수 
# SERVER_VERSION: 배포 버전 명
# SERVER_LIST: 배포 대상 서버 IP 목록

node {
    stage("Donwload binary") {
        echo "Downlaod server binary from AWS S3"
        echo "Server version= ${SERVER_VERSION}"
        downloadFile("${SERVER_VERSION}")
        sh '../check-file.sh'
    }
    
    echo "Deployment target server-list."
    echo "${SERVER_LIST}"
    
    def servers = SERVER_LIST.split('\n')
    for (int i = 0; i< servers.length; i++) {
        stage("Deploy to AWS Instance (${servers[i]})") {
            echo "Start deploying to ${servers[i]}" 
            ssh_publisher("${servers[i]}")
            echo "End deploying to ${servers[i]}" 
        }
    }
}


