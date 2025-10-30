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
  value       = tls_private_key.this[0].private_key_openssh
  sensitive   = true
}
