output "zone_id" {
  value       = data.aws_route53_zone.selected
  sensitive   = true
  description = "Hosted zone ID for the target domain"
}


# output records {
#   value       = [
#     for domain in aws_route_53.selected.: bd.name
#   ]
#   sensitive   = false
#   description = "description"
# }
