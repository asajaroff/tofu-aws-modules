# EC2

Provisions an EC2 instance of your choosing and some basic software to start with.

## `os_family`

* Debian
* Ubuntu
* FreeBSD
* NetBSD


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
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.3.5 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.allow_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.allow_all_traffic_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_ssh_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.debian](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.freebsd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudinit_config.debian](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | If true, will associate a public ip address with the created instance | `bool` | `false` | no |
| <a name="input_aws_ssm_enabled"></a> [aws\_ssm\_enabled](#input\_aws\_ssm\_enabled) | If true, enables AWS Session Manager for connecting to the instance | `string` | `true` | no |
| <a name="input_create_key"></a> [create\_key](#input\_create\_key) | Create an SSH key for connecting to the EC2 instace | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type, defaults to 't3.micro'<br>https://aws.amazon.com/ec2/instance-types/?nc1=h_ls | `string` | `"t3.micro"` | no |
| <a name="input_instances_map"></a> [instances\_map](#input\_instances\_map) | Map of instances to create.<br>The map accepts an "instance" object as defined in variables.tf<br>Example:<br>[<br>  {<br>    name = ".example.com",<br>    instance\_type = "t3.micro",<br>    disable\_api\_termination = false<br>  },<br>  {<br>    name = "mail.example.com",<br>    instance\_type = "t3.micro",<br>    disable\_api\_termination = false<br>  }<br>] | <pre>list(object({<br>    name                    = string<br>    instance_type           = string<br>    disable_api_termination = bool<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_os_arch"></a> [os\_arch](#input\_os\_arch) | Processor architecture, possible options:<br>- amd64<br>- arm64 | `string` | `"amd64"` | no |
| <a name="input_os_family"></a> [os\_family](#input\_os\_family) | The flavor for the EC2 instance to be deployed, possible options:<br>  - debian<br>  - ubuntu<br>  - freebsd | `string` | `"debian"` | no |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | Name for the instance pool.<br>IAM roles for the instance/s will be created with this variable. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the AWS provider will be configured and deployed | `string` | `"us-east-1"` | no |
| <a name="input_spot_enabled"></a> [spot\_enabled](#input\_spot\_enabled) | If true, the instance will be a spot-instance | `string` | `false` | no |
| <a name="input_spot_price"></a> [spot\_price](#input\_spot\_price) | The maximum hourly price that you're willing to pay for a Spot Instance | `number` | `0.005` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet where the resources will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC where the resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_info"></a> [instance\_info](#output\_instance\_info) | n/a |
| <a name="output_private_key"></a> [private\_key](#output\_private\_key) | n/a |
<!-- END_TF_DOCS -->