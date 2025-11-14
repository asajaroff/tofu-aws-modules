# Elastic IP Address

This module creates and manages AWS Elastic IP addresses (EIPs). Elastic IPs are static IPv4 addresses designed for dynamic cloud computing. They can be associated with EC2 instances or network interfaces to provide a persistent public IP address.

## Features

- Create Elastic IP addresses for VPC or EC2-Classic
- Optional association with EC2 instances
- Optional association with network interfaces
- Support for custom private IP association
- Flexible tagging support
- Lifecycle management

## Usage

### Basic EIP

```hcl
module "eip" {
  source = "git::https://github.com/asajaroff/tofu-aws-modules.git//modules/aws/eip?ref=aws/eip/v1.0.0"

  name = "web-server-eip"

  tags = {
    Environment = "production"
    ManagedBy   = "tofu"
  }
}
```

### EIP Associated with EC2 Instance

```hcl
module "eip_with_instance" {
  source = "git::https://github.com/asajaroff/tofu-aws-modules.git//modules/aws/eip?ref=aws/eip/v1.0.0"

  name        = "web-server-eip"
  instance_id = "i-1234567890abcdef0"

  tags = {
    Environment = "production"
    Application = "web"
  }
}
```

### EIP Associated with Network Interface

```hcl
module "eip_with_eni" {
  source = "git::https://github.com/asajaroff/tofu-aws-modules.git//modules/aws/eip?ref=aws/eip/v1.0.0"

  name                 = "nat-gateway-eip"
  network_interface_id = "eni-1234567890abcdef0"

  tags = {
    Purpose = "nat-gateway"
  }
}
```

### EIP with Specific Private IP

```hcl
module "eip_with_private_ip" {
  source = "git::https://github.com/asajaroff/tofu-aws-modules.git//modules/aws/eip?ref=aws/eip/v1.0.0"

  name                      = "multi-ip-server-eip"
  instance_id               = "i-1234567890abcdef0"
  associate_with_private_ip = "10.0.1.50"

  tags = {
    Configuration = "multi-ip"
  }
}
```

## Notes

- EIPs are limited per region (default is 5 per region, can be increased via AWS support)
- You are charged for EIPs that are allocated but not associated with a running instance
- EIPs can be moved between instances quickly (useful for failover scenarios)
- The `instance_id` and `network_interface_id` parameters are mutually exclusive
- Setting `prevent_destroy = true` in the lifecycle block can protect against accidental deletion

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.98.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_with_private_ip"></a> [associate\_with\_private\_ip](#input\_associate\_with\_private\_ip) | User-specified primary or secondary private IP address to associate with the EIP | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Indicates if this EIP is for use in VPC (vpc) or EC2-Classic (standard) | `string` | `"vpc"` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | EC2 instance ID to associate with the EIP. Conflicts with network\_interface\_id | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name tag for the Elastic IP | `string` | n/a | yes |
| <a name="input_network_interface_id"></a> [network\_interface\_id](#input\_network\_interface\_id) | Network interface ID to associate with the EIP. Conflicts with instance\_id | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for the Elastic IP | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_allocation_id"></a> [allocation\_id](#output\_allocation\_id) | ID that AWS assigns to represent the allocation of the Elastic IP address for use with instances in a VPC. |
| <a name="output_association_id"></a> [association\_id](#output\_association\_id) | ID representing the association of the address with an instance in a VPC. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Elastic IP. |
| <a name="output_ptr_record"></a> [ptr\_record](#output\_ptr\_record) | The DNS pointer (PTR) record for the IP address. |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | Public DNS associated with the Elastic IP address. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Contains the public IP address. |
<!-- END_TF_DOCS -->