pipeline {
    agent any

     tools {
       dockerTool 'docker' // Make sure Docker tool is configured in Jenkins
     }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        DOCKER_CREDENTIALS_ID = 'dockerhub-cred'
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
                            buildAndPush('services/frontend-service')
                        }
                    }
                }
                stage('webserver-service') {
                    steps {
                        script {
                            buildAndPush('services/webserver-service')
                        }
                    }
                }
                stage('app-service') {
                    steps {
                        script {
                            buildAndPush('services/app-service')
                        }
                    }
                }
                stage('api-gateway-service') {
                    steps {
                        script {
                            buildAndPush('services/api-gateway-service')
                        }
                    }
                }
                stage('business-logic-service') {
                    steps {
                        script {
                            buildAndPush('services/business-logic-service')
                        }
                    }
                }
                stage('message-queue-service') {
                    steps {
                        script {
                            buildAndPush('services/message-queue-service')
                        }
                    }
                }
                stage('data-access-service') {
                    steps {
                        script {
                            buildAndPush('services/data-access-service')
                        }
                    }
                }
                stage('cache-service') {
                    steps {
                        script {
                            buildAndPush('services/cache-service')
                        }
                    }
                }
                stage('storage-service') {
                    steps {
                        script {
                            buildAndPush('services/storage-service')
                        }
                    }
                }
                stage('infra-manager-service') {
                    steps {
                        script {
                            buildAndPush('services/infra-manager-service')
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

// instead of buildAndPush('services/my‑svc'), just pass the service name:
def buildAndPush(String serviceName) {
  script {
    def image = "cloudmahir19/stylestack/${serviceName}:latest"
    echo "🔧 Building ${image}…"
    // cd directly into services/<name>, not services/services/<name>
    dir("services/${serviceName}") {
      sh """
        docker build -t ${image} .
        docker push ${image}
        docker rmi ${image} || true
      """
    }
  }
}


// def buildAndPush(String servicePath) {
//     script {
//         def serviceName = servicePath.tokenize('/')[-1]
//         def imageName = "cloudmahir19/stylestack/${serviceName}:latest"
//
//         withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
//             dir("/var/lib/jenkins/workspace/10-Tier/services/${servicePath}") {
//                 sh """
//                     echo "Building image: ${imageName}"
//                     docker build -t ${imageName} .
//                     docker push ${imageName}
//                     docker rmi ${imageName}
//                 """
//             }
//         }
//     }
// }