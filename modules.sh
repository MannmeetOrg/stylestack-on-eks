#!/bin/bash

# Infra modules placeholders
for module in vpc eks rds s3 sqs elasticache iam network; do
  touch infra/modules/$module/{main.tf,variables.tf,outputs.tf}
done