#
# Example: Using the EC2 Module with Custom Cloud-Init Scripts
#
# This example demonstrates how to use custom bootstrap scripts and cloud-config
# files with the EC2 module instead of the default ones.
#

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# ============================================================================
# EC2 Module with Custom Cloud-Init Scripts
# ============================================================================

module "ec2_with_custom_cloudinit" {
  # Path to the EC2 module
  # Adjust this path based on where you've placed this example
  source = "../../"  # Points to modules/ec2

  # Basic configuration
  pool_name = "custom-cloudinit-example"
  region    = var.region
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  # Instance configuration
  instances_map = [
    {
      name                    = "custom-cloudinit-instance.example.com"
      instance_type           = "t3.micro"
      disable_api_termination = false
      volume_size             = 20
      public                  = true
    }
  ]

  # OS configuration
  os_family = "debian"  # Can be: debian, ubuntu, freebsd, flatcar
  os_arch   = "amd64"   # Can be: amd64, arm64

  # SSH access
  allow_ssh_ips = ["0.0.0.0/0"]  # CHANGE THIS! Use your actual IP for security

  # SSH key configuration
  create_key = true
  key_name   = "custom-cloudinit-example-key"

  # AWS SSM (Session Manager) configuration
  aws_ssm_enabled = true

  # ========================================================================
  # CUSTOM CLOUD-INIT SCRIPTS
  # ========================================================================
  # These are the key variables for using custom cloud-init configuration!
  #
  # Use path.root to reference files relative to THIS directory
  # (where you run terraform apply)
  # ========================================================================

  custom_bootstrap_script = "${path.root}/bootstrap-custom.sh"
  custom_cloud_config     = "${path.root}/cloud-config-custom.yaml"

  # Tags
  tags = {
    Environment = "development"
    Project     = "cloud-init-example"
    ManagedBy   = "terraform"
  }
}

# ============================================================================
# Alternative Example: Using Default Scripts
# ============================================================================

# If you want to use the default scripts, simply omit the custom_* variables:
#
# module "ec2_with_default_cloudinit" {
#   source = "../../"
#
#   pool_name = "default-cloudinit-example"
#   region    = var.region
#   vpc_id    = var.vpc_id
#   subnet_id = var.subnet_id
#
#   instances_map = [
#     {
#       name                    = "default-instance.example.com"
#       instance_type           = "t3.micro"
#       disable_api_termination = false
#       volume_size             = 20
#       public                  = true
#     }
#   ]
#
#   os_family = "debian"
#
#   # Note: custom_bootstrap_script and custom_cloud_config are NOT specified
#   # The module will use the default scripts from modules/ec2/config/
# }

# ============================================================================
# Outputs
# ============================================================================

output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = module.ec2_with_custom_cloudinit.instance_ids
}

output "instance_public_ips" {
  description = "Public IP addresses of the instances"
  value       = module.ec2_with_custom_cloudinit.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IP addresses of the instances"
  value       = module.ec2_with_custom_cloudinit.instance_private_ips
}

output "ssh_private_key" {
  description = "SSH private key for connecting to instances"
  value       = module.ec2_with_custom_cloudinit.ssh_private_key
  sensitive   = true
}
