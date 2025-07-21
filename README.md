# 10-Tier Microservices Application on AWS EKS

This project deploys a 10-tier microservices application on an AWS EKS cluster using Terraform, Jenkins, Docker, and Kubernetes. The application consists of 10 services (`frontend-service`, `webserver-service`, `app-service`, `api-gateway-service`, `business-logic-service`, `message-queue-service`, `data-access-service`, `cache-service`, `storage-service`, `infra-manager-service`) orchestrated via Kubernetes manifests and built/pushed using a Jenkins pipeline.

## Project Structure

```
project-root/
├── services/
│   ├── frontend-service/
│   │   ├── Dockerfile
│   │   ├── app.js
│   │   └── package.json
│   ├── webserver-service/
│   │   ├── Dockerfile
│   │   ├── app.js
│   │   └── package.json
│   ├── app-service/
│   ├── api-gateway-service/
│   ├── business-logic-service/
│   ├── message-queue-service/
│   ├── data-access-service/
│   ├── cache-service/
│   ├── storage-service/
│   ├── infra-manager-service/
├── k8s-manifests/
│   ├── deployments.yaml
│   ├── services.yaml
│   ├── ingress.yaml
│   └── config.yaml
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
├── scripts/
│   ├── deploy.sh
│   └── destroy.sh
├── Jenkinsfile
├── README.md
└── .gitignore
```

- **services/**: Contains 10 service directories, each with a `Dockerfile`, `app.js` (Node.js Express app), and `package.json`.
- **k8s-manifests/**: Kubernetes manifests for deployments, services, ingress, and ConfigMap.
- **infra/**: Terraform configurations for VPC, EC2, EKS, and IAM resources.
- **scripts/**: Shell scripts for deploying and destroying infrastructure.
- **Jenkinsfile**: Jenkins pipeline for building Docker images and deploying to EKS.
- **README.md**: This file.
- **.gitignore**: Excludes unnecessary files from version control.

## Prerequisites

- AWS account with credentials configured (`aws configure`).
- Terraform installed locally.
- Docker Hub account (`mannmeetorg`) with write access.
- SSH key pair named `10-tier-key` in `ap-south-1`.
- S3 bucket `10-tier-terraform-state` for Terraform state.
- Git repository: `https://github.com/MannmeetOrg/stylestack-on-eks.git`.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/MannmeetOrg/stylestack-on-eks.git
   cd stylestack-on-eks
   ```

2. **Deploy Infrastructure**:
   - Navigate to the `infra/` directory:
     ```bash
     cd infra
     terraform init
     terraform apply -auto-approve
     ```
   - Alternatively, use the provided script:
     ```bash
     ./scripts/deploy.sh
     ```
   - This creates:
     - A VPC with public subnets.
     - An EC2 instance (Ubuntu, t3.large, 30GB) with Jenkins, Docker, SonarQube, kubectl, and eksctl.
     - An EKS cluster (`my-eks2`) with a node group (`node2`).
     - IAM roles/policies for EC2 and EKS.
     - Kubernetes RBAC files (`sa.yaml`, `rol.yaml`, `bind.yaml`, `sec.yaml`) in `/home/ubuntu` on the EC2 instance.

3. **Configure Jenkins**:
   - Access Jenkins at `http://<EC2_PUBLIC_IP>:8080` (get `EC2_PUBLIC_IP` from Terraform outputs).
   - Complete the initial setup (retrieve admin password from `/var/lib/jenkins/secrets/initialAdminPassword` on the EC2 instance).
   - Install recommended plugins and the following:
     - SonarQube Scanner
     - Docker
     - Docker Pipeline
     - Docker Commons
     - CloudBees Docker Build and Publish
     - Kubernetes
     - Kubernetes CLI
   - Configure credentials:
     - `docker-cred`: Docker Hub credentials for `mannmeetorg`.
     - `k8-token`: Kubernetes token for EKS cluster (use `sec.yaml` secret or `aws eks update-kubeconfig`).
   - Configure SonarQube server (`sonar`) in Jenkins global configuration.

4. **Set Up Repository**:
   - Ensure the `src/` directory in `stylestack-on-eks` contains the `services/` subdirectories with `Dockerfile`, `app.js`, and `package.json`.
   - Push changes to `https://github.com/MannmeetOrg/stylestack-on-eks.git`.

5. **Run Jenkins Pipeline**:
   - Create a new pipeline job in Jenkins, pointing to the `Jenkinsfile` in the repository.
   - Trigger the pipeline to:
     - Check out the repository.
     - Run SonarQube analysis.
     - Build and push Docker images (`mannmeetorg/<service-name>:latest`) for all 10 services.
     - Deploy Kubernetes manifests to the `webapps` namespace on the EKS cluster.

6. **Access the Application**:
   - Get the ALB DNS name:
     ```bash
     kubectl get ingress -n webapps
     ```
   - Access:
     - `frontend-service` at `http://<ALB_DNS>/`.
     - `api-gateway-service` at `http://<ALB_DNS>/api`.
   - Verify pods and services:
     ```bash
     kubectl get pods -n webapps
     kubectl get svc -n webapps
     ```
   - Access SonarQube at `http://<EC2_PUBLIC_IP>:9000`.

## Cleaning Up

To destroy all resources:
```bash
./scripts/destroy.sh
```
This removes the EC2 instance, EKS cluster, VPC, and other resources.

## Notes

- **Customization**: Replace placeholder `app.js` files with actual service logic (e.g., add RabbitMQ for `message-queue-service`, Redis for `cache-service`).
- **Ports**: Services use port 8080. Update `Dockerfile`, `app.js`, `deployments.yaml`, and `services.yaml` if different ports are needed.
- **ALB Ingress Controller**: Ensure the AWS ALB Ingress Controller is installed (`--alb-ingress-access` in `eksctl`). If ingress fails, install it manually:
  ```bash
  kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//?ref=master"
  ```
- **Troubleshooting**:
  - If Docker push fails, verify `docker-cred` and `mannmeetorg` account access.
  - If Kubernetes deployment fails, check the EKS endpoint in `Jenkinsfile` matches `aws_eks_cluster.main.endpoint` from Terraform outputs.
  - If plugins fail to install, run `java -jar /usr/share/jenkins/jenkins.war -s http://localhost:8080/ install-plugin <plugin-name>` on the EC2 instance.