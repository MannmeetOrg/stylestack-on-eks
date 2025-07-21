#!/bin/bash

echo "🔧 Creating Helm chart directory structure..."

# Define base path
BASE_DIR="stylestack-on-eks/helm-charts/generic-service"

# Create directories
mkdir -p $BASE_DIR/templates

# Create Chart.yaml
cat <<EOF > $BASE_DIR/Chart.yaml
apiVersion: v2
name: generic-service
description: A generic Helm chart for Kubernetes microservices
type: application
version: 0.1.0
appVersion: "1.0.0"
EOF

# Create values.yaml
cat <<EOF > $BASE_DIR/values.yaml
replicaCount: 2

image:
  repository: stylestack-on-eks/generic-service
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: Prefix
  tls: []

resources: {}

EOF

# Create deployment.yaml
cat <<EOF > $BASE_DIR/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "generic-service.fullname" . }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "generic-service.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "generic-service.name" . }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}
EOF

# Create service.yaml
cat <<EOF > $BASE_DIR/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "generic-service.fullname" . }}
spec:
  type: {{ .
