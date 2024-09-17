# Cloudfront + S3 static site hosting

## Requirements
* A route53 Hosted Zone with the top level domain name of the site to deploy
* Resources for certificate manager and certificate manager validation must be in `us-east-1`

## Upload template site for testing

```bash
cd templates/
S3_BUCKET_NAME=bucket_name aws s3 sync ./ s3://${S3_BUCKET_NAME}/public/
```