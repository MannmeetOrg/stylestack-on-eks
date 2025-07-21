# infra/backend.tf
terraform {
  backend "s3" {
    bucket         = "stylestack-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
  }
}
