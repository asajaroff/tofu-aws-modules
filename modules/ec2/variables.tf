variable instance_name {
  type        = string
  description = "Name for the instance"
}


variable associate_public_ip_address {
  type = bool
  default = false
  description = "If true, will associate a public ip address with the created instance"
}

variable aws_ssm_enabled {
  type        = string
  default     = true
  description = "If true, enables AWS Session Manager for connecting to the instance"
}

variable instance_type {
  type = string
  default = "t3.micro"
  description = <<EOT
The instance type, defaults to 't3.micro'
https://aws.amazon.com/ec2/instance-types/?nc1=h_ls
EOT
}

variable "os_arch" {
  type = string
  default = "amd64"
  description = <<EOT
Processor architecture, possible options:
- amd64
- arm64
EOT
}

variable "os_family" {
  type = string
  default = "debian"
  description = <<EOT
  The flavor for the EC2 instance to be deployed, possible options:
  - debian
  - ubuntu
  - freebsd
EOT
}

variable "tags" {
    default = {}
    type = map(string)
}

variable "region" {
  type        = string
  default     = "us-east-1"
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
