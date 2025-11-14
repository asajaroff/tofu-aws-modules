# AWS Cloudfront module

A module to deploy an AWS Cloudfront distribution with an `s3_origin`.

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
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.s3_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_route53_record.base_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.base_domain_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.www](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.top_level_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Extra CNAMEs (alternate domain names), if any, for this distribution. | `string` | n/a | yes |
| <a name="input_aws_acm_certificate_arn"></a> [aws\_acm\_certificate\_arn](#input\_aws\_acm\_certificate\_arn) | An ARN for a certificate, it must be created on the 'us-east-1' region. | `string` | n/a | yes |
| <a name="input_country_blacklist"></a> [country\_blacklist](#input\_country\_blacklist) | A list of countries to blacklist, in the form of | `list(string)` | <pre>[<br/>  "CN",<br/>  "RU",<br/>  "PK",<br/>  "IN",<br/>  "KP"<br/>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the CDN distribution to be created | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the site, do not include the top level domain | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | 'prod' or 'non-prod' | `string` | n/a | yes |
| <a name="input_mount_cloudfront_default_certificate"></a> [mount\_cloudfront\_default\_certificate](#input\_mount\_cloudfront\_default\_certificate) | Wether to mount CloudFront DNS certificate -for development- | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the AWS provider will be configured and deployed | `string` | n/a | yes |
| <a name="input_s3_bucket_id"></a> [s3\_bucket\_id](#input\_s3\_bucket\_id) | The bucket name for the S3 origin. | `string` | `"bucket-name"` | no |
| <a name="input_s3_bucket_regional_domain_name"></a> [s3\_bucket\_regional\_domain\_name](#input\_s3\_bucket\_regional\_domain\_name) | Regional domain name for the target bucket. | `string` | n/a | yes |
| <a name="input_s3_origin_path"></a> [s3\_origin\_path](#input\_s3\_origin\_path) | Path to the folder, if any, where the site is located | `string` | `""` | no |
| <a name="input_top_level_domain_name"></a> [top\_level\_domain\_name](#input\_top\_level\_domain\_name) | Top level domain name, written as 'domain.example.com.'<br/>Will be used to fetch the hosted zone id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_https_url"></a> [cloudfront\_https\_url](#output\_cloudfront\_https\_url) | URL of the CloudFront distribution, for testing purposes. |
| <a name="output_cloudfront_name"></a> [cloudfront\_name](#output\_cloudfront\_name) | DNS name of the target Cloudfront distribution for the website. |
| <a name="output_cloudfront_zone_id"></a> [cloudfront\_zone\_id](#output\_cloudfront\_zone\_id) | Cloudfront distribution ID for the alias of the website. |
| <a name="output_route53_record_fqdn"></a> [route53\_record\_fqdn](#output\_route53\_record\_fqdn) | n/a |
| <a name="output_route53_record_name"></a> [route53\_record\_name](#output\_route53\_record\_name) | n/a |
<!-- END_TF_DOCS -->