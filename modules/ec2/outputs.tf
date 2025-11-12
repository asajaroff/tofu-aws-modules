output "instance_info" {
  description = "Map of instance information including IDs, IP addresses, and instance types for all created instances"
  value = {
    for instance_id, instance in aws_instance.this :
    instance_id => {
      id            = instance.id
      public_ip     = instance.public_ip
      private_ip    = instance.private_ip
      instance_type = instance.instance_type
    }
  }
}

output "private_key" {
  description = "The auto-generated SSH private key in OpenSSH format for connecting to instances (sensitive)"
  value       = var.create_key ? tls_private_key.this[0].private_key_openssh : null
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the security group created for SSH access"
  value       = aws_security_group.allow_ssh.id
}

output "iam_role_name" {
  description = "Name of the IAM role created for the instances"
  value       = aws_iam_role.this.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role created for the instances"
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile attached to the instances"
  value       = aws_iam_instance_profile.this.name
}

output "key_pair_name" {
  description = "Name of the SSH key pair (null if create_key is false)"
  value       = var.create_key ? aws_key_pair.this[0].key_name : null
}

output "ami_id" {
  description = "ID of the AMI used for the instances"
  value       = local.selected_ami
}

output "instance_arns" {
  description = "Map of instance ARNs"
  value = {
    for instance_id, instance in aws_instance.this :
    instance_id => instance.arn
  }
}
