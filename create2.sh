#!/bin/bash

echo "📁 Creating Kubernetes manifests folder structure..."

# Create k8s-manifests directory structure
mkdir -p k8s-manifests/{namespaces,deployments,services,ingress,configmaps-secrets,rbac,hpa}

# Namespaces
touch k8s-manifests/namespaces/{dev-namespace.yaml,staging-namespace.yaml,prod-namespace.yaml}

# Deployments
for svc in frontend webserver application api-gateway business-logic message-queue data-access cache storage infrastructure; do
  touch k8s-manifests/deployments/${svc}-deployment.yaml
done

# Services
for svc in frontend webserver application api-gateway business-logic message-queue data-access cache storage infrastructure; do
  touch k8s-manifests/services/${svc}-service.yaml
done

# Ingress
touch k8s-manifests/ingress/{ingress-dev.yaml,ingress-staging.yaml,ingress-prod.yaml}

# ConfigMaps and Secrets
touch k8s-manifests/configmaps-secrets/{frontend-configmap.yaml,application-configmap.yaml,db-secret.yaml,redis-secret.yaml,api-gateway-secret.yaml}

# RBAC
touch k8s-manifests/rbac/{sa-jenkins.yaml,jenkins-role.yaml,jenkins-rolebinding.yaml,developer-readonly-role.yaml}

# HPA
touch k8s-manifests/hpa/{frontend-hpa.yaml,application-hpa.yaml,business-logic-hpa.yaml}


echo "📦 Creating services source code structure..."

# Create services structure
mkdir -p services/{frontend,webserver,application,api-gateway,business-logic,message-queue,data-access,cache,storage,infrastructure}

# Add placeholder Dockerfiles and base files
for svc in frontend webserver application api-gateway business-logic message-queue data-access cache storage infrastructure; do
  echo -e "# Dockerfile for $svc\nFROM alpine\nCMD [\"echo\", \"$svc service\"]" > services/$svc/Dockerfile
  touch services/$svc/README.md
done

echo "✅ Project structure created!"
