# Simple Storage Server (S3) module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.66.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_website_configuration.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_block_public_access"></a> [block\_public\_access](#input\_block\_public\_access) | If true, will create a block for S3 bucket-level Public Access Block configuration | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length | `string` | `""` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Creates a unique bucket name beginning with the specified prefix | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Wheather to force the destruction of this bucket even if it has objects. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the AWS provider will be configured and deployed | `string` | n/a | yes |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the bucket. Will be of format arn:aws:s3:::bucketname |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | S3 bucket regional domain name. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Name of the bucket |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | Route 53 Hosted Zone ID for this bucket's region |
<!-- END_TF_DOCS -->