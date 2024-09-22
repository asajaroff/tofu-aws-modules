variable "pool_name" {
  type        = string
  description = <<EOT
Name for the instance pool.
IAM roles for the instance/s will be created with this variable.
EOT
}

variable "instances_map" {
  type = list(object({
    name                    = string
    instance_type           = string
    disable_api_termination = bool
    volume_size             = number
    public                  = true
    }
  ))
  description = <<EOT
Map of instances to create.
The map accepts an "instance" object as defined in variables.tf
Example:
[
  {
    name = ".example.com",
    instance_type = "t3.micro",
    disable_api_termination = false
  },
  {
    name = "mail.example.com",
    instance_type = "t3.micro",
    disable_api_termination = false
  }
]
EOT
}

variable "spot_enabled" {
  type        = string
  default     = false
  description = "If true, the instance will be a spot-instance"
}

variable "spot_price" {
  type        = number
  default     = 0.005
  description = "The maximum hourly price that you're willing to pay for a Spot Instance"
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "If true, will associate a public ip address with the created instance"
}

variable "aws_ssm_enabled" {
  type        = string
  default     = true
  description = "If true, enables AWS Session Manager for connecting to the instance"
}

variable "os_arch" {
  type        = string
  default     = "amd64"
  description = <<EOT
Processor architecture, possible options:
- amd64
- arm64
EOT
}

variable "os_family" {
  type        = string
  default     = "debian"
  description = <<EOT
  The flavor for the EC2 instance to be deployed, possible options:
  - debian
  - ubuntu
  - freebsd
EOT
}

variable "tags" {
  default = {}
  type    = map(string)
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
