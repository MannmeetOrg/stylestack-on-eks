#!/bin/bash


# Terraform Infrastructure Creation
cd infra/
terraform init
terraform apply -auto-approve


#set -e
#
## Setup AWS CLI config using GitHub Secrets
#mkdir -p ~/.aws
#
#cat > ~/.aws/credentials <<EOL
#[default]
#aws_access_key_id = ${AWS_ACCESS_KEY_ID}
#aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
#EOL
#
#cat > ~/.aws/config <<EOL
#[default]
#region = ap-south-1
#output = json
#EOL
#
## Optional: export as env vars for Terraform
#export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
#export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
#export AWS_DEFAULT_REGION=ap-south-1
#
#echo "✅ AWS CLI configured successfully from deploy.sh"