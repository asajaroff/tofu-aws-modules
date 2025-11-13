variable "name" {
  type        = string
  description = <<EOT
Name for the instance group.
Used as a prefix for IAM roles, security groups, and other resources.
EOT
}

variable "instances" {
  type = list(object({
    name                    = string
    instance_type           = string
    disable_api_termination = bool
    volume_size             = number
    public                  = bool
    }
  ))
  description = <<EOT
List of instances to create.
Example:
[
  {
    name                    = "instance1.example.com"
    instance_type           = "t3.micro"
    disable_api_termination = false
    volume_size             = 10
    public                  = true
  },
  {
    name                    = "instance2.example.com"
    instance_type           = "t3.large"
    disable_api_termination = false
    volume_size             = 20
    public                  = false
  }
]
EOT
}

variable "allow_ssh_ips" {
  type        = list(string)
  default     = ["192.168.1.1/32"]
  description = <<EOT
List IP address that will be allowed to SSH into the box.
Format is "123.123.123.123/32"
EOT
}

variable "allow_ssh_ipv6_ips" {
  type        = list(string)
  default     = []
  description = <<EOT
List of IPv6 addresses that will be allowed to SSH into the box.
Format is "2001:db8::1/128" for single addresses or "2001:db8::/64" for ranges.
If empty, no IPv6 SSH access will be allowed.
EOT
}

variable "spot_enabled" {
  type        = bool
  default     = false
  description = "If true, the instance will be a spot-instance"
}

variable "spot_price" {
  type        = number
  default     = 0.005
  description = "The maximum hourly price that you're willing to pay for a Spot Instance"
}

variable "enable_ssm" {
  type        = bool
  default     = true
  description = "If true, enables AWS Session Manager for connecting to instances"
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
  - flatcar
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

variable "create_ssh_key" {
  type        = bool
  default     = true
  description = "If true, creates an SSH key pair for connecting to EC2 instances"
}

variable "ssh_key_name" {
  type        = string
  default     = "terraform-ec2-module-key"
  description = "Name of the SSH key pair to create (only used if create_ssh_key is true)"
}

variable "custom_bootstrap_script" {
  type        = string
  default     = ""
  description = <<EOT
Path to a custom bootstrap script relative to the root module (where you invoke this module).
If provided, this will be used instead of the default bootstrap script.
Use path.root in your module invocation, e.g., "$${path.root}/scripts/custom-bootstrap.sh"
EOT
}

variable "custom_cloud_config" {
  type        = string
  default     = ""
  description = <<EOT
Path to a custom cloud-config YAML file relative to the root module (where you invoke this module).
If provided, this will be used instead of the default cloud-config.
Use path.root in your module invocation, e.g., "$${path.root}/config/custom-cloud-config.yaml"
EOT
}
