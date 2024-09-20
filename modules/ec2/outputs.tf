output "ubuntu_ami" {
  value       = data.aws_ami.ubuntu.image_id
  sensitive   = false
  description = "Latest AMI for ubuntu 24.04"
}

output "debian_ami" {
  value       = data.aws_ami.debian.image_id
  sensitive   = false
  description = "Latest AMI for debian 12"
}

output "freebsd_ami" {
  value       = data.aws_ami.freebsd.image_id
  sensitive   = false
  description = "Latest AMI for FreeBSD 14.1"
}

output "instance_public_ip" {
  value       = aws_instance.this.public_ip
  sensitive   = false
  description = "Public IP address of the instance"
}

output "private_key" {
  value     = tls_private_key.this[0].private_key_openssh
  sensitive = true
}

output "connection_string" {
  value       = "ssh -i ~/.ssh/discard ec2-user@${aws_instance.this.public_ip}"
  sensitive   = false
  description = "One-liner to connect to the created instance"
}
