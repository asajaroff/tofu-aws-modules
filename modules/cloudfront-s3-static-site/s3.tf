resource "aws_s3_bucket" "site_bucket" {
  bucket = var.s3_bucket_name

  tags = merge(
  {
    "Name" = "Static site for ${var.s3_bucket_name}"
  },
  var.extra_tags)
}

resource "aws_s3_bucket_acl" "site_bucket_acl" {
  bucket = aws_s3_bucket.site_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}


data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.site_bucket.arn,
      "${aws_s3_bucket.site_bucket.arn}/${var.site_deploy_folder}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.static_site.arn]
    }
  }
}
