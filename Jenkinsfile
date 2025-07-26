pipeline {
    agent any

    tools {
      dockerTool 'docker' // Make sure Docker tool is configured in Jenkins
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds'
        DOCKER_HUB_REPO = 'cloudmahir19/stylestack'
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
                    steps {
                        script {
                            buildAndPush('frontend-service')
                        }
                    }
                }
                stage('webserver-service') {
                    steps {
                        script {
                            buildAndPush('webserver-service')
                        }
                    }
                }
                stage('app-service') {
                    steps {
                        script {
                            buildAndPush('app-service')
                        }
                    }
                }
                stage('api-gateway-service') {
                    steps {
                        script {
                            buildAndPush('api-gateway-service')
                        }
                    }
                }
                stage('business-logic-service') {
                    steps {
                        script {
                            buildAndPush('business-logic-service')
                        }
                    }
                }
                stage('message-queue-service') {
                    steps {
                        script {
                            buildAndPush('message-queue-service')
                        }
                    }
                }
                stage('data-access-service') {
                    steps {
                        script {
                            buildAndPush('data-access-service')
                        }
                    }
                }
                stage('cache-service') {
                    steps {
                        script {
                            buildAndPush('cache-service')
                        }
                    }
                }
                stage('storage-service') {
                    steps {
                        script {
                            buildAndPush('storage-service')
                        }
                    }
                }
                stage('infra-manager-service') {
                    steps {
                        script {
                            buildAndPush('infra-manager-service')
                        }
                    }
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

// def buildAndPush(String servicePath) {
//     script {
//         def imageName = "cloudmahir19/stylestack/${servicePath.tokenize('/')[-1]}:latest"
//         withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
//             dir("/var/lib/jenkins/workspace/10-Tier/src/${servicePath}") {
//                 sh "docker build -t ${imageName} ."
//                 sh "docker push ${imageName}"
//                 sh "docker rmi ${imageName}"
//             }
//         }
//     }
// }

def buildAndPush(String servicePath) {
    script {
        def serviceName = servicePath.tokenize('/')[-1]
        def imageName = "cloudmahir19/stylestack/${serviceName}:latest"

        withDockerRegistry(credentialsId: 'docker-cred', toolname: 'docker' {
            dir("/var/lib/jenkins/workspace/10-Tier/services/${servicePath}") {
                sh """
                    echo "Building image: ${imageName}"
                    docker build -t ${imageName} .
                    docker push ${imageName}
                    docker rmi ${imageName}
                """
            }
        }
    }
}