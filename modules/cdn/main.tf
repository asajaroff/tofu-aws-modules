# resource "aws_s3_bucket_acl" "b_acl" {
#   bucket = aws_s3_bucket.b.id
#   acl    = "private"
# }
resource "aws_cloudfront_origin_access_control" "s3_origin" {
  name                              = var.cdn_origin_access_control_name
  description                       = var.cdn_origin_access_control_comment
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin.id
    origin_id                = var.s3_bucket_id
    origin_path              = var.s3_origin_path
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cdn_comment
  default_root_object = "index.html"

#  logging_config {
#    include_cookies = false
#    bucket          = "mylogs.s3.amazonaws.com"
#    prefix          = "myprefix"
#  }

#  aliases = ["sample.alias.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = var.country_blacklist
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
