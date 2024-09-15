variable "region" {
  type        = string
  description = "Region where the AWS provider will be configured and deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC where the resources will be created"
}

variable "subnet_id" {
  type        = string
  description = "Subnet where the resources will be created"
}

variable "create_key" {
  type        = bool
  default     = true
  description = "Create an SSH key for connecting to the EC2 instace"
}
