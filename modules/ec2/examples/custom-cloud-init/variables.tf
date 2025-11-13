variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where resources will be created"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EC2 instance will be created"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the EC2 instance will be created"
}
