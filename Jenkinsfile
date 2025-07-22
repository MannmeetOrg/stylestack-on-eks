pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MannmeetOrg/stylestack-on-eks.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=10-Tier \
                        -Dsonar.projectName=10-Tier \
                        -Dsonar.java.binaries=.'''
                }
            }
        }

        stage('Build & Push Docker Images') {
            parallel {
                stage('frontend-service') {
                    steps { buildAndPush('frontend-service') }
                }
                stage('webserver-service') {
                    steps { buildAndPush('webserver-service') }
                }
                stage('app-service') {
                    steps { buildAndPush('app-service') }
                }
                stage('api-gateway-service') {
                    steps { buildAndPush('api-gateway-service') }
                }
                stage('business-logic-service') {
                    steps { buildAndPush('business-logic-service') }
                }
                stage('message-queue-service') {
                    steps { buildAndPush('message-queue-service') }
                }
                stage('data-access-service') {
                    steps { buildAndPush('data-access-service') }
                }
                stage('cache-service') {
                    steps { buildAndPush('cache-service') }
                }
                stage('storage-service') {
                    steps { buildAndPush('storage-service') }
                }
                stage('infra-manager-service') {
                    steps { buildAndPush('infra-manager-service') }
                }
            }
        }

        stage('K8s Deploy') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'my-eks2',
                    contextName: '',
                    credentialsId: 'k8-token',
                    namespace: 'webapps',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://EBCE08CF45C3AA5A574E126370E5D4FC.gr7.ap-south-1.eks.amazonaws.com'
                ) {
                    sh 'kubectl apply -f k8s-manifests/deployments.yaml'
                    sh 'kubectl apply -f k8s-manifests/services.yaml'
                    sh 'kubectl apply -f k8s-manifests/ingress.yaml'
                    sh 'kubectl apply -f k8s-manifests/config.yaml'
                    sh 'kubectl get pods'
                    sh 'kubectl get svc'
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution complete!"
        }
    }
}

def buildAndPush(String servicePath) {
    script {
        def imageName = "cloudmahir19/stylestack/${servicePath.tokenize('/')[-1]}:latest"
        withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
            dir("/var/lib/jenkins/workspace/10-Tier/src/${servicePath}") {
                sh "docker build -t ${imageName} ."
                sh "docker push ${imageName}"
                sh "docker rmi ${imageName}"
            }
        }
    }
}