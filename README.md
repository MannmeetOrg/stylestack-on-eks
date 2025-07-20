# stylestack-on-eks
10-Microservices E-Commerce Platform on AWS EKS

project-root/
│
├── infra/                              # All Infrastructure as Code lives here
│   ├── modules/                        # Reusable Terraform modules (VPC, EKS, RDS, etc.)
│   │   ├── vpc/
│   │   ├── eks/
│   │   ├── rds/
│   │   ├── s3/
│   │   ├── sqs/
│   │   ├── elasticache/
│   │   ├── iam/
│   │   └── network/
│   ├── environments/                   # Per-environment configuration
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   ├── terraform.tfvars
│   │   │   └── backend.tf              # S3/DynamoDB remote state configuration
│   │   ├── staging/
│   │   │   └── ...
│   │   └── prod/
│   │       └── ...
│   └── README.md                       # Infra/terraform usage documentation
│
├── k8s-manifests/                      # Native Kubernetes YAMLs
│   ├── namespaces/
│   ├── deployments/
│   ├── services/
│   ├── ingress/
│   ├── configmaps-secrets/
│   ├── rbac/
│   └── hpa/
│
├── services/                           # Application source code for all microservices
│   ├── frontend/
│   ├── webserver/
│   ├── application/
│   ├── api-gateway/
│   ├── business-logic/
│   ├── message-queue/
│   ├── data-access/
│   ├── cache/
│   ├── storage/
│   └── infrastructure/                 # Supporting code/utilities if needed
│
├── scripts/                            # Helper scripts for deployment, clean up, etc
│   ├── deploy.sh
│   ├── destroy.sh
│   └── utils/
│
├── Jenkinsfile                         # CI/CD pipeline for app (build, test, deploy)
├── README.md                           # Project documentation
└── .gitignore

