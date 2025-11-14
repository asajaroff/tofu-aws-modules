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
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Top level domain for the hosted zone, either 'example.com' or 'subdomain.example.com' | `string` | n/a | yes |
| <a name="input_is_private"></a> [is\_private](#input\_is\_private) | Boolean to check if the target hosted zone is private | `bool` | `"false"` | no |
| <a name="input_record_type"></a> [record\_type](#input\_record\_type) | Type of Registry | `string` | `"A"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the AWS provider will be configured and deployed | `string` | `"us-east-1"` | no |
| <a name="input_target"></a> [target](#input\_target) | List of IP Addresses to include | `string` | `"us-east-1"` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL of the entry | `number` | `"3600"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Hosted zone ID for the target domain |
<!-- END_TF_DOCS -->