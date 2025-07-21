# Jenkins Credentials Setup

This document outlines the secrets and credentials required in Jenkins for the 10-tier microservices application pipeline. These credentials are used in the `Jenkinsfile` to interact with Docker Hub, the AWS EKS cluster, and SonarQube.

## Required Credentials

1. **Docker Hub Credentials (`docker-cred`)**
   - **Purpose**: Authenticate with Docker Hub to push images (`mannmeetorg/<service-name>:latest`).
   - **Type**: Username with Password.
   - **Details**:
     - **Username**: Your Docker Hub username (e.g., `mannmeetorg`).
     - **Password**: Your Docker Hub password or access token (recommended).
   - **Configuration**:
     - Go to **Manage Jenkins > Manage Credentials > System > Global credentials > Add Credentials**.
     - Set:
       - **Kind**: Username with Password.
       - **Scope**: Global.
       - **Username**: `<your-dockerhub-username>`.
       - **Password**: `<your-dockerhub-password-or-token>`.
       - **ID**: `docker-cred`.
       - **Description**: Docker Hub credentials for pushing images.
     - Ensure the `mannmeetorg` Docker Hub account has write access.

2. **Kubernetes Credentials (`k8-token`)**
   - **Purpose**: Authenticate with the EKS cluster (`my-eks2`) to apply Kubernetes manifests.
   - **Type**: Secret Text (preferred) or Secret File.
   - **Details**:
     - **Secret Text**: Use the service account token from the `mysecretname` secret in the `webapps` namespace.
     - **Secret File**: Use a `kubeconfig` file for the EKS cluster.
   - **Configuration (Secret Text)**:
     - SSH into the EC2 instance using the `10-tier-key` key pair.
     - Run:
       ```bash
       kubectl -n webapps get secret mysecretname -o jsonpath='{.data.token}' | base64 --decode
       ```
     - In Jenkins:
       - **Kind**: Secret Text.
       - **Scope**: Global.
       - **Secret**: Paste the decoded token.
       - **ID**: `k8-token`.
       - **Description**: Kubernetes service account token for EKS.
   - **Configuration (Secret File)**:
     - On the EC2 instance, run:
       ```bash
       aws eks update-kubeconfig --region ap-south-1 --name my-eks2
       ```
     - Copy `~/.kube/config` to your local machine.
     - In Jenkins:
       - **Kind**: Secret File.
       - **Scope**: Global.
       - **File**: Upload the `kubeconfig` file.
       - **ID**: `k8-token`.
       - **Description**: kubeconfig for EKS cluster.
     - **Note**: The Secret Text option is recommended as `userdata.sh` creates the `mysecretname` secret.

3. **SonarQube Token (`sonar`)**
   - **Purpose**: Authenticate with the SonarQube server (`http://<EC2_PUBLIC_IP>:9000`) for code analysis.
   - **Type**: Secret Text.
   - **Details**: A user token generated from the SonarQube UI.
   - **Configuration**:
     - Access SonarQube at `http://<EC2_PUBLIC_IP>:9000`.
     - Log in (default: admin/admin, change password if prompted).
     - Go to **My Account > Security > Generate Tokens**, create a token (e.g., “Jenkins SonarQube Token”).
     - In Jenkins:
       - **Kind**: Secret Text.
       - **Scope**: Global.
       - **Secret**: Paste the SonarQube token.
       - **ID**: `sonar`.
       - **Description**: SonarQube token for analysis.
     - Configure the SonarQube server:
       - Go to **Manage Jenkins > Configure System > SonarQube servers > Add SonarQube**.
       - Set:
         - **Name**: `sonar`.
         - **Server URL**: `http://localhost:9000` (SonarQube runs on the EC2 instance).
         - **Server authentication token**: Select the `sonar` credential.

## Notes
- **AWS Credentials**: The EC2 instance uses an IAM role (`EKSFullAccessRole`) for AWS access, so no AWS credentials are needed in Jenkins.
- **Security**: Use Docker Hub access tokens instead of passwords for `docker-cred`. Store the Kubernetes token securely and avoid exposing it.
- **Troubleshooting**:
  - If Docker push fails, verify `docker-cred` and `mannmeetorg` account access.
  - If Kubernetes deployment fails, ensure the `k8-token` matches the EKS cluster’s service account or `kubeconfig`.
  - If SonarQube authentication fails, regenerate the token and verify the server URL.