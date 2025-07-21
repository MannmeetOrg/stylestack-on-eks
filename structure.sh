#!/bin/bash

echo "🔧 Initializing Stylestack Alt Project Structure..."

# Create service directories with Dockerfiles
services=(
  frontend-service webserver-service app-service api-gateway-service
  business-logic-service message-queue-service data-access-service
  cache-service storage-service infra-manager-service
)

for svc in "${services[@]}"; do
  mkdir -p  services/$svc
  cat <<EOF >  services/$svc/Dockerfile
# Dockerfile for $svc
FROM alpine
CMD ["echo", "$svc running"]
EOF
done

# Create Kubernetes manifests folder and files
mkdir -p  k8s-manifests
touch  k8s-manifests/{deployments.yaml,services.yaml,ingress.yaml,config.yaml}

# Create Terraform infra files
mkdir -p  infra
touch  infra/{main.tf,variables.tf,outputs.tf}
cat <<EOF >  infra/backend.tf
terraform {
  backend "s3" {
    bucket         = "stylestack-tf-state"
    key            = "global/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "stylestack-locks"
  }
}
EOF

# Create script files
mkdir -p scripts
echo -e "#!/bin/bash\nkubectl apply -f k8s-manifests/" > scripts/deploy.sh
echo -e "#!/bin/bash\nkubectl delete -f k8s-manifests/" > scripts/destroy.sh
chmod +x  scripts/*.sh

# Create root-level files
cat <<EOF >  Jenkinsfile
pipeline {
  agent any
  stages {
    stage('Deploy') {
      steps {
        sh './scripts/deploy.sh'
      }
    }
  }
}
EOF

echo "# Stylestack Simplified" >  README.md
echo -e "node_modules/\n.env\n*.tfstate\n*.zip\n__pycache__/\n.DS_Store" >  .gitignore

echo "✅ Project structure created under  "
