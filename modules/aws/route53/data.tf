data "aws_route53_zone" "selected" {
  name         = var.hosted_zone
  private_zone = var.is_private
}
