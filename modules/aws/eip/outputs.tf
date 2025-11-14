# outputs.tf
output "id" {
  value       = aws_eip.this.id
  description = "The ID of the Elastic IP."
}

output "public_ip" {
  value       = aws_eip.this.public_ip
  description = "Contains the public IP address."
}

output "public_dns" {
  value       = aws_eip.this.public_dns
  description = "Public DNS associated with the Elastic IP address."
}

output "allocation_id" {
  value       = aws_eip.this.allocation_id
  description = "ID that AWS assigns to represent the allocation of the Elastic IP address for use with instances in a VPC."
}

output "association_id" {
  value       = aws_eip.this.association_id
  description = "ID representing the association of the address with an instance in a VPC."
}

output "ptr_record" {
  value       = aws_eip.this.ptr_record
  description = "The DNS pointer (PTR) record for the IP address."
}
