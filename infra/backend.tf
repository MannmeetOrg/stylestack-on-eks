terraform {
  backend "s3" {
    bucket = "10-tier-terraform-state"
    key    = "state/terraform.tfstate"
    region = "ap-south-1"
  }
}