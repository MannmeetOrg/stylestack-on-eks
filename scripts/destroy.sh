#!/bin/bash

cd infra/
terraform init
terraform destroy -auto-approve