#!/bin/bash

echo "🔧 Creating Stylestack-on-EKS Project Structure..."

mkdir -p stylestack-on-eks/{infra/{modules/{vpc,eks,rds,s3,sqs,elasticache,iam,network},environments/{dev,staging,prod}},k8s-manifests/{namespaces,deployments,services,ingress,configmaps-secrets,rbac,hpa},services/{frontend,webserver,application,api-gateway,business-logic,message-queue,data-access,cache,storage,infrastructure},scripts/utils}

cd stylestack-on-eks

# Infra modules placeholders
for module in vpc eks rds s3 sqs elasticache iam network; do
  touch infra/modules/$module/{main.tf,variables.tf,outputs.tf}
done

# Infra environment files
for env in dev staging prod; do
  mkdir -p infra/environments/$env
  touch infra/environments/$env/{main.tf,variables.tf,outputs.tf,terraform.tfvars,backend.tf}
done

touch infra/README.md

# Kubernetes manifests
touch k8s-manifests/namespaces/{dev-namespace.yaml,staging-namespace.yaml,prod-namespace.yaml}
touch k8s-manifests/ingress/{ingress-dev.yaml,ingress-staging.yaml,ingress-prod.yaml}
touch k8s-manifests/configmaps-secrets/{frontend-configmap.yaml,application-configmap.yaml,db-secret.yaml,redis-secret.yaml,api-gateway-secret.yaml}
touch k8s-manifests/rbac/{sa-jenkins.yaml,jenkins-role.yaml,jenkins-rolebinding.yaml,developer-readonly-role.yaml}
touch k8s-manifests/hpa/{frontend-hpa.yaml,application-hpa.yaml,business-logic-hpa.yaml}
touch k8s-manifests/kustomization.yaml

for svc in frontend webserver application api-gateway business-logic message-queue data-access cache storage infrastructure; do
  touch k8s-manifests/deployments/${svc}-deployment.yaml
  touch k8s-manifests/services/${svc}-service.yaml
done

# Services Dockerfiles and readmes
for svc in frontend webserver application api-gateway business-logic message-queue data-access cache storage infrastructure; do
  echo -e "# Dockerfile for $svc\nFROM alpine\nCMD [\"echo\", \"$svc\"]" > services/$svc/Dockerfile
  echo "# $svc service" > services/$svc/README.md
done

# Scripts
touch scripts/{deploy.sh,destroy.sh}
touch scripts/utils/helpers.sh

# Project-level files
touch Jenkinsfile
touch README.md
echo -e "node_modules/\n.env\n*.tfstate\n*.zip\n__pycache__/" > .gitignore

echo "✅ Stylestack-on-EKS project structure initialized."
