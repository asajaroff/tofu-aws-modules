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

variable "additional_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<EOT
List of additional security group IDs to attach to the instances.
This allows attaching custom security groups (e.g., for HTTP, HTTPS, or application-specific rules)
alongside the module's default SSH security group.
Example: ["sg-12345678", "sg-87654321"]
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

variable "additional_iam_policy_arns" {
  type        = list(string)
  default     = []
  description = <<EOT
List of additional IAM policy ARNs to attach to the instance role.
Useful for granting instances access to AWS services like S3, DynamoDB, etc.
Example: ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
EOT
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

variable "custom_ami_id" {
  type        = string
  default     = null
  description = <<EOT
Custom AMI ID to use for the instances instead of automatic OS family selection.
When specified, this overrides the os_family automatic AMI selection.
Useful for using golden images, hardened AMIs, or specific AMI versions.
Example: "ami-0123456789abcdef0"
EOT
}

variable "root_volume_encrypted" {
  type        = bool
  default     = true
  description = "If true, the root EBS volume will be encrypted"
}

variable "root_volume_kms_key_id" {
  type        = string
  default     = null
  description = <<EOT
KMS key ID to use for root volume encryption.
If not specified, the default AWS EBS encryption key will be used.
Only applies when root_volume_encrypted is true.
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

variable "additional_ebs_volumes" {
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = optional(string, "gp3")
    iops                  = optional(number, null)
    throughput            = optional(number, null)
    encrypted             = optional(bool, true)
    kms_key_id            = optional(string, null)
    delete_on_termination = optional(bool, true)
    mount_point           = string
    filesystem_type       = optional(string, "ext4")
  }))
  default = []
  description = <<EOT
List of additional EBS volumes to attach to ALL instances.
Each volume will be automatically formatted, mounted, and added to /etc/fstab.

Example:
[
  {
    device_name     = "/dev/sdf"
    volume_size     = 100
    volume_type     = "gp3"
    iops            = 3000
    throughput      = 125
    encrypted       = true
    mount_point     = "/data"
    filesystem_type = "ext4"
  }
]

Notes:
- device_name: Use /dev/sd[f-p] for additional volumes
- volume_type: gp3 (default), gp2, io1, io2, st1, sc1
- iops: Only for gp3, io1, io2 (gp3: 3000-16000, io1/io2: 100-64000)
- throughput: Only for gp3 (125-1000 MB/s)
- filesystem_type: ext4 (default), xfs, ext3
- Volumes are created per instance (if you have 3 instances, 3 volumes are created)
EOT
}
