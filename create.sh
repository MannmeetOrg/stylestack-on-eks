#!/bin/bash

mkdir -p {infra/{modules/{vpc,eks,rds,s3,sqs,elasticache,iam,network},environments/{dev,staging,prod}},k8s-manifests/{namespaces,deployments,services,ingress,configmaps-secrets,rbac,hpa},services/{frontend,webserver,application,api-gateway,business-logic,message-queue,data-access,cache,storage,infrastructure},scripts/utils}

# Infra environment files
touch  infra/environments/dev/{main.tf,variables.tf,outputs.tf,terraform.tfvars,backend.tf}
touch  infra/environments/staging/.gitkeep
touch  infra/environments/prod/.gitkeep

# Infra modules placeholders
for module in vpc eks rds s3 sqs elasticache iam network; do
  touch infra/modules/$module/{main.tf,variables.tf,outputs.tf}
done

# Core project files
touch  infra/README.md
touch  scripts/{deploy.sh,destroy.sh}
touch  Jenkinsfile
touch  README.md
touch  .gitignore

echo "✅ Project structure created. Next: git init & push to repo."

