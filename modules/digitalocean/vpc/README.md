# Module template

Placeholder for module description.

## Design

Placeholder for design.
Provide information on how the module is designed and how it's intended to be used.

A [docs](./docs/) folder is also provided for including more extensive notes.

## Usage

Placeholder for usage.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.68.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_vpc.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | Token | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the VPC | `string` | `"tofu-aws-modules-tests"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the VPC will be deployed | `string` | `"ams3"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | variables.tf | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->