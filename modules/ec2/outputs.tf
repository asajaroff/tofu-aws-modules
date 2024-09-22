output "instance_info" {
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
  value     = tls_private_key.this[0].private_key_openssh
  sensitive = true
}
