# Jenkinsfile
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh './scripts/build.sh'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push stylestack/frontend-service:latest'
        sh 'docker push stylestack/webserver-service:latest'
        sh 'docker push stylestack/app-service:latest'
      }
    }
    stage('Deploy') {
      steps {
        sh './scripts/deploy.sh'
      }
    }
  }
}
