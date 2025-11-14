# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#argument-reference
resource "aws_s3_bucket" "this" {
  # bucket        = var.bucket_name # Either this or `bucket_prefix`
  bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.block_public_access == false ? 0 : 1
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
