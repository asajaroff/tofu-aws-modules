# EC2 Module

A flexible Terraform/OpenTofu module for provisioning EC2 instances with customizable configurations including multiple OS options, spot instances, SSH key management, and IAM role integration.

## Features

- **Multiple OS Support**: Deploy Debian, Ubuntu, or FreeBSD instances
- **Architecture Flexibility**: Support for both amd64 and arm64 architectures
- **Spot Instance Support**: Optional spot instance provisioning with configurable pricing
- **Automated SSH Key Generation**: Automatically creates and manages SSH key pairs
- **IAM Integration**: Built-in IAM role and instance profile creation
- **AWS SSM Support**: Optional AWS Session Manager integration for secure access
- **Cloud-init Configuration**: Automated instance initialization and software installation
- **Security Group Management**: Preconfigured security groups with customizable SSH access
- **Multi-Instance Deployment**: Deploy multiple instances with different configurations in a single module call

## Usage

### Basic Example

```hcl
module "ec2_instances" {
  source = "./modules/ec2"

  pool_name = "my-app-pool"
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-87654321"

  instances_map = [
    {
      name                    = "web-server.example.com"
      instance_type           = "t3.micro"
      disable_api_termination = false
      volume_size             = 20
      public                  = true
    }
  ]
}
```

### Multiple Instances with Different Configurations

```hcl
module "ec2_instances" {
  source = "./modules/ec2"

  pool_name = "multi-tier-app"
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-87654321"

  instances_map = [
    {
      name                    = "web.example.com"
      instance_type           = "t3.micro"
      disable_api_termination = false
      volume_size             = 20
      public                  = true
    },
    {
      name                    = "db.example.com"
      instance_type           = "t3.large"
      disable_api_termination = true
      volume_size             = 100
      public                  = false
    }
  ]

  os_family = "ubuntu"
  os_arch   = "amd64"
  region    = "us-west-2"

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### Spot Instance Configuration

```hcl
module "ec2_spot" {
  source = "./modules/ec2"

  pool_name     = "spot-pool"
  vpc_id        = "vpc-12345678"
  subnet_id     = "subnet-87654321"
  spot_enabled  = true
  spot_price    = 0.01

  instances_map = [
    {
      name                    = "batch-worker.example.com"
      instance_type           = "t3.medium"
      disable_api_termination = false
      volume_size             = 30
      public                  = false
    }
  ]
}
```

## Security Configuration

### SSH Access Control

Configure which IP addresses can SSH into your instances using the `allow_ssh_ip` variable:

```hcl
module "ec2_instances" {
  source = "./modules/ec2"

  # ... other variables ...

  allow_ssh_ip = "203.0.113.0/32"  # Replace with your IP address
}
```

**Important**: The default value is `192.168.1.1/32`. Always set this to your actual IP address or CIDR block for security.

## Accessing Instances

### SSH Access

If `create_key` is enabled (default), the module generates an SSH key pair. Retrieve the private key from the outputs:

```bash
terraform output -raw private_key > instance_key.pem
chmod 600 instance_key.pem
ssh -i instance_key.pem admin@<instance-ip>
```

**Note**: The default username depends on the OS:
- Debian: `admin`
- Ubuntu: `ubuntu`
- FreeBSD: `freebsd`

### AWS Session Manager

If `aws_ssm_enabled` is true (default), connect via AWS SSM:

```bash
aws ssm start-session --target <instance-id>
```

This method doesn't require SSH keys or open ports and works with both public and private instances.

## Important Notes

- **Instance Recreation**: Changing the `name` field in `instances_map` will cause the instance to be destroyed and recreated
- **Metadata Security**: IMDSv2 is enforced for enhanced security (`http_tokens = "required"`)
- **Volume Management**: Root volumes are configured with gp3 (General Purpose SSD) and are deleted on instance termination
- **IAM Roles**: A shared IAM role and instance profile are created for all instances in the pool using the `pool_name` variable
- **Spot Instances**: When enabled, instances use the `stop` interruption behavior to preserve data during spot interruptions

## Outputs

After applying the module, you can retrieve information about your instances:

```bash
# Get all instance information
terraform output instance_info

# Get the private SSH key (sensitive)
terraform output -raw private_key
```

## TODO
- [ ] Update to debian 13
- [ ] Changing names recreates instances

---

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
| <a name="input_instances_map"></a> [instances\_map](#input\_instances\_map) | Map of instances to create.<br>The map accepts an "instance" object as defined in variables.tf<br>Example:<br>[<br>  {<br>    name = ".example.com",<br>    instance\_type = "t3.micro",<br>    disable\_api\_termination = false<br>  },<br>  {<br>    name = "mail.example.com",<br>    instance\_type = "t3.micro",<br>    disable\_api\_termination = false<br>  }<br>] | <pre>list(object({<br>    name                    = string<br>    instance_type           = string<br>    disable_api_termination = bool<br>    volume_size             = number<br>    public                  = true<br>    }<br>  ))</pre> | n/a | yes |
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