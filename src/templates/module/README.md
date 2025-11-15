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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | Region where the AWS provider will be configured and deployed | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC where the resources will be created | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
