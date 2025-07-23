#!/bin/bash

set -e

# Setup AWS CLI config using GitHub Secrets
mkdir -p ~/.aws

cat > ~/.aws/credentials <<EOL
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOL

cat > ~/.aws/config <<EOL
[default]
region = ap-south-1
output = json
EOL

echo "✅ AWS CLI configured successfully from deploy.sh"

# Terraform Infrastructure Creation
cd infra/
terraform init
terraform apply -auto-approve