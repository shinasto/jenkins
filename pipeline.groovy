node {
    def app
    stage('Preparation') {
      // git clone
      git branch: 'master',
          credentialsId: 'github-credentialId',
          url: 'https://github.com/shinasto/test.git'
      
      // settings JDK Version 
      def javaHome = tool name: 'Openjdk-11'
      echo "${javaHome}"
      env.JAVA_HOME = "${javaHome}"
      env.PATH = "${env.PATH}:${env.JAVA_HOME}/bin"
     }
    stage('Build') {
      // Run the maven build
      sh 'mvn -f ./ht-core-framework/pom.xml -gs /var/jenkins_home/settings.xml clean package -DskipTests'
    }
    stage('Results') {
      // junit 'ht-core-framework/target/surefire-reports/TEST-*.xml'
      archive 'target/*.jar'
    }
    stage('Build docker image') {
        dir('./Docker') {
            // using docker plugin
            app = docker.build("hdservicedocker/ht-core-framework")
        }
    }
    stage('Push docker image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
