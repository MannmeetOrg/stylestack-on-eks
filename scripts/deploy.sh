#!/bin/bash


# Terraform Infrastructure Creation
cd infra/
terraform init
terraform apply -auto-approve

