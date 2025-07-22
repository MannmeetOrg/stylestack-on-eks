#!/bin/bash

# Update system
apt-get update -y
apt-get upgrade -y

# AWS CLI Install
sudo apt update
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
aws configure

# Input values (expected from environment variables like GitHub Secrets)
AWS_ACCESS_KEY_ID= "${{ secrets.AWS_ACCESS_KEY_ID }}"
AWS_SECRET_ACCESS_KEY= "${{ secrets.AWS_SECRET_ACCESS_KEY }}"
AWS_REGION="ap-south-1"
AWS_OUTPUT="json"

# Install Jenkins
sudo apt install -y openjdk-21-jdk
java -version
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
echo "deb https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list
apt-get update -y
apt-get install -y jenkins

# Start and enable Jenkins
systemctl start jenkins
systemctl enable jenkins

# Install Docker
apt-get install -y docker.io
usermod -aG docker ubuntu
newgrp docker

# Install SonarQube
docker run -d -p 9000:9000 sonarqube:lts-community

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
chmod +x /usr/local/bin/eksctl

# Create Kubernetes namespace
kubectl create namespace webapps

# Create Kubernetes YAML files
cat <<EOF > /home/ubuntu/sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: webapps
  labels:
    app: jenkins
    environment: dev
EOF

cat <<EOF > /home/ubuntu/rol.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
  namespace: webapps
rules:
  - apiGroups:
      - ""
      - apps
      - autoscaling
      - batch
      - extensions
      - policy
      - rbac.authorization.k8s.io
    resources:
      - pods
      - configmaps
      - deployments
      - daemonsets
      - componentstatuses
      - events
      - endpoints
      - horizontalpodautoscalers
      - ingress
      - jobs
      - limitranges
      - namespaces
      - nodes
      - persistentvolumes
      - persistentvolumeclaims
      - resourcequotas
      - replicasets
      - replicationcontrollers
      - serviceaccounts
      - services
    verbs:
      - get
      - list
      - watch
      - create
      - update
      - patch
      - delete
EOF

cat <<EOF > /home/ubuntu/bind.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-rolebinding
  namespace: webapps
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: app-role
subjects:
  - kind: ServiceAccount
    name: jenkins
    namespace: webapps
EOF

cat <<EOF > /home/ubuntu/sec.yaml
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: mysecretname
  namespace: webapps
  annotations:
    kubernetes.io/service-account.name: jenkins
  labels:
    app: jenkins
EOF

# Apply Kubernetes configurations
kubectl apply -f /home/ubuntu/sa.yaml
kubectl apply -f /home/ubuntu/rol.yaml
kubectl apply -f /home/ubuntu/bind.yaml
kubectl apply -f /home/ubuntu/sec.yaml

# Install Jenkins plugins
JENKINS_HOME=/var/lib/jenkins
JENKINS_CLI=/usr/share/jenkins/jenkins.war
java -jar $JENKINS_CLI -s http://localhost:8080/ install-plugin sonarqube-scanner
java -jar $JENKINS_CLI -s http://localhost:8080/ install-plugin docker-plugin
java -jar $JENKINS_CLI -s http://localhost:8080/ install-plugin docker-workflow
java -jar $JENKINS_CLI -s http://localhost:8080/ install-plugin docker-commons
java -jar $JENKINS_CLI -s http://localhost:8080/ install-plugin cloudbees-docker-build-publish
java -jar $JENKINS_CLI -s http://localhost:8080/ install-plugin kubernetes
java -jar $JENKINS_CLI -s http://localhost:8080/ install-plugin kubernetes-cli
systemctl restart jenkins

# Configure EKS cluster
eksctl create cluster --name=my-eks2 \
  --region=ap-south-1 \
  --zones=ap-south-1a,ap-south-1b \
  --without-nodegroup

eksctl utils associate-iam-oidc-provider \
  --region ap-south-1 \
  --cluster my-eks2 \
  --approve

eksctl create nodegroup --cluster=my-eks2 \
  --region=ap-south-1 \
  --name=node2 \
  --node-type=t3.medium \
  --nodes=3 \
  --nodes-min=2 \
  --nodes-max=3 \
  --node-volume-size=20 \
  --ssh-public-key=10-tier-key \
  --managed \
  --asg-access \
  --external-dns-access \
  --full-ecr-access \
  --appmesh-access \
  --alb-ingress-access