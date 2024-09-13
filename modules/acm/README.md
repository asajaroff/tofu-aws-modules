# AWS Certificate Manager module

Generates an ACM certificate for the given domain.

Top level domain name and subdomain must be provided as different argiments so that the `data` block can capture the DNS hosted zone automagically.
If your FQDN is `site.example.com`, then you must provide:
* `top_level_domain_name = example.com`
* `domain_name = site`

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
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.dns_validation_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Final domain name of the certificate.<br>A DNS record for "www.$\{value\}" will be also created. | `string` | n/a | yes |
| <a name="input_top_level_domain_name"></a> [top\_level\_domain\_name](#input\_top\_level\_domain\_name) | Top level domain name, written as 'domain.example.com.'<br>Will be used to fetch the hosted zone id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_website_arn"></a> [acm\_website\_arn](#output\_acm\_website\_arn) | ARN of the certificate |
| <a name="output_acm_website_cert_id"></a> [acm\_website\_cert\_id](#output\_acm\_website\_cert\_id) | ARN of the certificate -but its called id- |
| <a name="output_acm_website_certificate_status"></a> [acm\_website\_certificate\_status](#output\_acm\_website\_certificate\_status) | Status of the certificate. |
| <a name="output_acm_website_certificate_type"></a> [acm\_website\_certificate\_type](#output\_acm\_website\_certificate\_type) | Status of the certificate. |
| <a name="output_acm_website_domain_name"></a> [acm\_website\_domain\_name](#output\_acm\_website\_domain\_name) | Domain name for which the certificate is issued |
<!-- END_TF_DOCS -->