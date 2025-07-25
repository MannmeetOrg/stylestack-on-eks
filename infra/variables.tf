variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  default     = "10.0.2.0/24"
}

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  default     = "10-tier-key"
}

variable "manage_aws_auth" {
  type    = bool
  default = false
}