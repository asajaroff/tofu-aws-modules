# EC2 Module

A flexible Terraform/OpenTofu module for provisioning EC2 instances with customizable configurations including multiple OS options, spot instances, SSH key management, and IAM role integration.

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Basic Example](#basic-example)
  - [OS Selection](#os-selection)
  - [Multiple Instances](#multiple-instances-with-different-configurations)
  - [Spot Instances](#spot-instance-configuration)
  - [Complete Production Example](#complete-production-example)
- [Network Requirements](#network-requirements)
- [Security Configuration](#security-configuration)
- [Accessing Instances](#accessing-instances)
- [Cloud-Init Customization](#cloud-init-customization)
- [Outputs](#outputs)
- [Troubleshooting](#troubleshooting)
- [Limitations & Known Issues](#limitations--known-issues)
- [Architecture](#architecture)
- [Terraform Documentation](#requirements)

## Features

- **Multiple OS Support**: Deploy Debian, Ubuntu, FreeBSD, or Flatcar Container Linux instances
- **Architecture Flexibility**: Support for both amd64 and arm64 architectures
- **Spot Instance Support**: Optional spot instance provisioning with configurable pricing
- **Automated SSH Key Generation**: Automatically creates and manages SSH key pairs
- **IAM Integration**: Built-in IAM role and instance profile creation
- **AWS SSM Support**: Optional AWS Session Manager integration for secure access
- **Cloud-init Configuration**: Automated instance initialization and software installation
- **Security Group Management**: Preconfigured security groups with customizable SSH access
- **Multi-Instance Deployment**: Deploy multiple instances with different configurations in a single module call
- **IPv6 Support**: Optional IPv6 configuration (disabled by default to prevent NAT64 issues)

## Quick Start

```bash
# 1. Clone or reference the module
# 2. Create a basic configuration
cat > main.tf <<'EOF'
module "ec2" {
  source = "./modules/ec2"

  name      = "my-instances"
  vpc_id    = "vpc-xxxxx"      # Replace with your VPC ID
  subnet_id = "subnet-xxxxx"   # Replace with your subnet ID

  allow_ssh_ips = ["YOUR_IP/32"]  # Replace with your IP

  instances = [{
    name                    = "test.example.com"
    instance_type           = "t3.micro"
    disable_api_termination = false
    volume_size             = 20
    public                  = true
  }]
}

output "instance_ip" {
  value = module.ec2.instance_info["test.example.com"].public_ip
}
EOF

# 3. Deploy
terraform init
terraform plan
terraform apply

# 4. Save SSH key and connect
terraform output -raw private_key > key.pem
chmod 600 key.pem
ssh -i key.pem admin@$(terraform output -raw instance_ip)
```

## Prerequisites

- **Terraform/OpenTofu** >= 1.1
- **AWS CLI** configured with appropriate credentials
- **VPC with appropriate networking**:
  - For public instances: Subnet with route to Internet Gateway
  - For private instances: Subnet with route to NAT Gateway
- Basic understanding of AWS networking concepts

## Usage

### Basic Example

```hcl
module "ec2_instances" {
  source = "./modules/ec2"

  name      = "my-app"
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-87654321"

  instances = [
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

### OS Selection

The module supports multiple operating systems and architectures.

#### Ubuntu 22.04 LTS (Default: Debian)

```hcl
module "ubuntu_instance" {
  source = "./modules/ec2"

  name = "ubuntu-pool"
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-87654321"

  os_family = "ubuntu"
  os_arch   = "amd64"

  instances = [
    {
      name                    = "ubuntu.example.com"
      instance_type           = "t3.micro"
      disable_api_termination = false
      volume_size             = 20
      public                  = true
    }
  ]
}
```

#### Flatcar Container Linux

```hcl
module "flatcar_instance" {
  source = "./modules/ec2"

  name = "flatcar-pool"
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-87654321"

  os_family = "flatcar"
  os_arch   = "amd64"  # or "arm64"

  instances = [
    {
      name                    = "flatcar.example.com"
      instance_type           = "t3.micro"
      disable_api_termination = false
      volume_size             = 20
      public                  = true
    }
  ]
}
```

#### FreeBSD 14.1 on ARM64

```hcl
module "freebsd_arm" {
  source = "./modules/ec2"

  name = "freebsd-pool"
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-87654321"

  os_family = "freebsd"
  os_arch   = "arm64"

  instances = [
    {
      name                    = "freebsd.example.com"
      instance_type           = "t4g.micro"  # Graviton2
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

  name = "multi-tier-app"
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-87654321"

  instances = [
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

  instances = [
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

### Complete Production Example

```hcl
# VPC and networking (separate module/resources)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false  # HA setup
}

# EC2 instances in private subnet
module "app_servers" {
  source = "./modules/ec2"

  name = "production-app"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnets[0]  # Private subnet with NAT

  os_family = "ubuntu"
  os_arch   = "amd64"
  region    = "us-east-1"

  allow_ssh_ips   = ["203.0.113.0/32"]  # Your office IP
  enable_ssm =true

  instances = [
    {
      name                    = "app-01.prod.example.com"
      instance_type           = "t3.medium"
      disable_api_termination = true
      volume_size             = 50
      public                  = false
    },
    {
      name                    = "app-02.prod.example.com"
      instance_type           = "t3.medium"
      disable_api_termination = true
      volume_size             = 50
      public                  = false
    }
  ]

  tags = {
    Environment = "production"
    Terraform   = "true"
    ManagedBy   = "terraform"
  }
}

# Attach additional IAM policy for S3 access
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = module.app_servers.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Outputs
output "instance_details" {
  value = module.app_servers.instance_info
}

output "ssh_key" {
  value     = module.app_servers.private_key
  sensitive = true
}
```

## Network Requirements

### Public Instances (`public = true`)

**Requires:**
- Subnet with route to Internet Gateway (`0.0.0.0/0 → igw-xxx`)
- Public IP assignment enabled (handled automatically by module)

**Use cases:**
- Web servers requiring direct internet access
- Jump boxes/bastion hosts
- Development/testing environments

### Private Instances (`public = false`)

**Requires:**
- Subnet with route to NAT Gateway (`0.0.0.0/0 → nat-xxx`) for internet access
- **Or**: VPC endpoints for AWS services (SSM, S3, etc.) if no internet access needed

**Use cases:**
- Production application servers
- Database servers
- Internal services
- Enhanced security posture

**Note**: Private instances can still access the internet through NAT Gateway for package updates, git cloning, etc.

### IPv6 Configuration

**Default**: IPv6 is **disabled** by default to prevent connectivity issues.

**Common Issue**: When IPv6 is enabled without proper VPC configuration, you may experience:
- NAT64 synthetic addresses (64:ff9b::/96) that don't work
- Git/SSH operations timing out after 30-60 seconds
- DNS returning non-functional IPv6 addresses

**To enable IPv6**, you must:
1. Ensure your VPC has IPv6 CIDR blocks configured
2. Configure Internet Gateway or Egress-Only Internet Gateway
3. Set up proper IPv6 routes in your route table
4. Enable IPv6 in the module:

```hcl
module "ec2_instances" {
  source = "./modules/ec2"

  enable_ipv6                = true
  enable_ipv6_security_rules = true  # Allows outbound traffic, blocks inbound ports < 10000
  ipv6_address_count         = 1

  # Optional: Allow IPv6 SSH access
  allow_ssh_ipv6_ips = ["2001:db8::/32"]

  # ... other configuration ...
}
```

**Security**: IPv6 rules allow all outbound traffic and incoming traffic only on ports 10000-65535.

📖 **See [IPv6-CONFIGURATION.md](./IPv6-CONFIGURATION.md) for detailed setup instructions and troubleshooting.**

## Security Configuration

### Built-in Security Features

- ✅ **IMDSv2 Enforced**: Prevents SSRF attacks on instance metadata
- ✅ **Egress Allowed**: All outbound traffic permitted for updates/packages
- ✅ **SSH Restricted**: Ingress limited to specified IP addresses only
- ✅ **SSM Access**: Optional Session Manager for keyless access
- ✅ **Latest AMIs**: Automatically uses most recent official images

### SSH Access Control

Configure which IP addresses can SSH into your instances using the `allow_ssh_ips` variable (accepts a list):

```hcl
module "ec2_instances" {
  source = "./modules/ec2"

  # ... other variables ...

  # Single IP
  allow_ssh_ips = ["203.0.113.0/32"]

  # Multiple IPs/ranges
  allow_ssh_ips = [
    "203.0.113.0/32",    # Office
    "198.51.100.0/24",   # VPN range
  ]
}
```

**Important**: The default value is `["192.168.1.1/32"]`. Always set this to your actual IP address or CIDR block for security.

**Get your current IP:**
```bash
# Linux/macOS
curl -s ifconfig.me

# Use in Terraform
allow_ssh_ips = ["${chomp(data.http.myip.response_body)}/32"]
```

### Security Recommendations

1. **Restrict SSH Access**: Always specify `allow_ssh_ips` - don't rely on defaults
2. **Use SSM When Possible**: Enable `enable_ssm` and use Session Manager instead of SSH
3. **Private Subnets for Production**: Use private subnets with NAT for production workloads
4. **Enable Termination Protection**: Set `disable_api_termination = true` for critical instances
5. **Regular Updates**: Module uses `most_recent = true` for AMIs, but patch instances regularly
6. **Least Privilege IAM**: Attach only necessary IAM policies to the instance role
7. **Monitor Access**: Enable CloudTrail and VPC Flow Logs for audit trails

## Accessing Instances

### SSH Access

If `create_ssh_key` is enabled (default), the module generates an SSH key pair. Retrieve the private key from the outputs:

```bash
terraform output -raw private_key > instance_key.pem
chmod 600 instance_key.pem
ssh -i instance_key.pem <username>@<instance-ip>
```

**Default SSH Usernames by OS**:

| OS Family | Default Username | Notes |
|-----------|------------------|-------|
| `debian` | `admin` | Debian official AMI default user |
| `ubuntu` | `ubuntu` | Ubuntu official AMI default user |
| `freebsd` | `ec2-user` | FreeBSD official AMI default user |
| `flatcar` | `core` | Flatcar Container Linux default user |

**Example SSH commands:**
```bash
# Debian
ssh -i instance_key.pem admin@<instance-ip>

# Ubuntu
ssh -i instance_key.pem ubuntu@<instance-ip>

# FreeBSD
ssh -i instance_key.pem ec2-user@<instance-ip>

# Flatcar
ssh -i instance_key.pem core@<instance-ip>
```

### AWS Session Manager

If `enable_ssm` is true (default), connect via AWS SSM without SSH keys:

```bash
# Connect to instance
aws ssm start-session --target <instance-id>

# Port forwarding (e.g., for web apps)
aws ssm start-session --target <instance-id> \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["80"],"localPortNumber":["8080"]}'
```

**Benefits of SSM:**
- No SSH keys required
- No open inbound ports needed
- Works with both public and private instances
- Centralized access logging
- Session recording capabilities

This method doesn't require SSH keys or open ports and works with both public and private instances.

## Cloud-Init Customization

The module includes bootstrap scripts for each OS that run on first boot:

| OS | Files | Installed Packages |
|----|-------|-------------------|
| **Debian** | `config/bootstrap-debian.sh`<br>`config/cloud-config-debian.yaml` | ansible, git, python3, neovim, curl (via apt) |
| **Ubuntu** | `config/bootstrap-ubuntu.sh`<br>`config/cloud-config-ubuntu.yaml` | ansible, git, python3, neovim, curl (via apt) |
| **FreeBSD** | `config/bootstrap-freebsd.sh`<br>`config/cloud-config-freebsd.yaml` | ansible, git, python3, neovim, curl (via pkg)<br>SSM Agent for FreeBSD |
| **Flatcar** | `config/bootstrap-flatcar.sh`<br>`config/cloud-config-flatcar.yaml` | SSM Agent (runs as Docker container)<br>Container-optimized OS |

### What Happens on First Boot

1. **Bootstrap script** runs (installs SSM agent, basic packages)
2. **Cloud-config** applies (SSH keys, user configuration)
3. **Instance becomes ready** for use

### Customizing Bootstrap

To customize what gets installed:

1. **Fork the module** or copy to your own repository
2. **Edit config files** in `config/` directory
3. **Modify as needed**:
   - Add/remove packages in bootstrap scripts
   - Change cloud-config settings
   - Add custom scripts

**Example modification** (`config/bootstrap-ubuntu.sh`):
```bash
#!/bin/bash
# Add your custom packages here
apt-get update
apt-get install -y ansible git python3 neovim curl docker.io
```

## Outputs

The module provides the following outputs for integration with other resources:

| Output | Description | Type | Usage Example |
|--------|-------------|------|---------------|
| `instance_info` | Map of instance details (ID, IPs, type) | `map(object)` | Get instance metadata |
| `private_key` | SSH private key (sensitive) | `string` | Save for SSH access |
| `security_group_id` | Security group ID | `string` | Add additional rules |
| `iam_role_name` | IAM role name | `string` | Attach additional policies |
| `iam_role_arn` | IAM role ARN | `string` | Reference in IAM policies |
| `iam_instance_profile_name` | Instance profile name | `string` | Use in other modules |
| `key_pair_name` | SSH key pair name | `string` | Reference for other instances |
| `ami_id` | Selected AMI ID | `string` | Track which AMI was used |
| `instance_arns` | Map of instance ARNs | `map(string)` | Use in resource policies |

### Usage Examples

**Get instance information:**
```bash
# View all instance details
terraform output instance_info

# Get specific instance IP
terraform output -json instance_info | jq -r '."web.example.com".public_ip'
```

**Save SSH key:**
```bash
terraform output -raw private_key > key.pem
chmod 600 key.pem
```

**Attach additional IAM policy:**
```hcl
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = module.ec2_instances.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
```

**Add security group rule:**
```hcl
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = module.ec2_instances.security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
```

**Reference in other resources:**
```hcl
resource "aws_lb_target_group_attachment" "app" {
  for_each = module.ec2_instances.instance_info

  target_group_arn = aws_lb_target_group.app.arn
  target_id        = each.value.id
  port             = 80
}
```

## Troubleshooting

### Cannot SSH to Instance

**Symptoms**: Connection timeout or "Connection refused"

**Diagnostic steps:**
```bash
# 1. Check security group allows your IP
terraform output security_group_id
aws ec2 describe-security-groups --group-ids <sg-id>

# 2. Verify instance has public IP (if using public subnet)
terraform output instance_info

# 3. Check you're using correct username
# See "Default SSH Usernames by OS" table above

# 4. Verify SSH key permissions
ls -la instance_key.pem  # Should be -rw------- (600)
```

**Solutions:**
- Add your IP to `allow_ssh_ips`
- Ensure instance has `public = true` if in public subnet
- Check route table has IGW route
- Use correct SSH username for OS

### Cannot Clone Git Repositories / No Internet Access

**Symptoms**: `git clone` hangs at "Cloning into...", package updates fail

**Diagnostic steps from instance:**
```bash
# Test DNS resolution
nslookup github.com

# Test internet connectivity
ping -c 4 8.8.8.8
ping -c 4 github.com

# Test HTTPS connectivity
curl -I https://github.com

# Check routing
ip route show default
```

**Common causes and solutions:**

1. **Private subnet without NAT Gateway**
   - **Symptom**: No default route or route to NAT
   - **Solution**: Add NAT Gateway to subnet's route table
   ```bash
   # Check route table
   aws ec2 describe-route-tables \
     --filters "Name=association.subnet-id,Values=<subnet-id>"
   ```

2. **Public subnet without IGW route**
   - **Symptom**: `public = true` but no internet
   - **Solution**: Add IGW route (`0.0.0.0/0 → igw-xxx`) to route table

3. **DNS resolution issues**
   - **Symptom**: Can ping 8.8.8.8 but not github.com
   - **Solution**: Check VPC DNS settings (`enableDnsHostnames`, `enableDnsSupport`)

### Instance Recreation on Apply

**Symptom**: Terraform wants to destroy and recreate instance

**Cause**: Changed the `name` field in an instance within the `instances` list

**Why**: Terraform uses `name` as the resource key (see `for_each` in `main.tf`)

**Solutions:**
1. **Don't change names** - Use tags for metadata
2. **Use terraform state mv** to preserve instance:
   ```bash
   terraform state mv \
     'module.ec2.aws_instance.this["old-name"]' \
     'module.ec2.aws_instance.this["new-name"]'
   ```
3. **Plan migrations** - Accept recreation for major changes

### SSM Session Manager Not Working

**Symptoms**: Cannot start SSM session, "TargetNotConnected" error

**Diagnostic steps:**
```bash
# Check if SSM agent is running
sudo systemctl status amazon-ssm-agent  # Debian/Ubuntu
sudo service amazon-ssm-agent status    # FreeBSD
docker ps | grep ssm                    # Flatcar

# Check IAM permissions
aws iam get-role-policy \
  --role-name <role-name> \
  --policy-name SSMPolicy
```

**Solutions:**
- Ensure `aws_ssm_enabled = true` in module call
- Verify IAM role has SSM permissions (module creates this automatically)
- For private instances: Add VPC endpoints for SSM (or use NAT Gateway)
- Check instance has internet access to reach SSM service

### Wrong AMI Selected

**Symptom**: Instance launches with unexpected OS version

**Diagnostic:**
```bash
# Check which AMI was selected
terraform output ami_id

# Query AMI details
aws ec2 describe-images --image-ids <ami-id>
```

**Solution:**
- Module uses `most_recent = true` - this is intentional
- To pin specific AMI version, modify data source filters in `data.tf`
- Check AWS region - AMI IDs differ per region

## Limitations & Known Issues

### Current Limitations

1. **Instance Name Changes Cause Recreation**
   - Changing the `name` field in `instances` destroys and recreates the instance
   - Terraform limitation due to `for_each` key
   - Workaround: Use tags for changeable metadata

2. **Shared IAM Role**
   - All instances share the same IAM role
   - Cannot have different permissions per instance
   - Workaround: Use separate module calls with different `name` values

3. **Single Security Group**
   - All instances share one security group
   - Cannot have per-instance firewall rules
   - Workaround: Create additional security groups and attach manually

4. **Embedded Cloud-Init**
   - Cloud-init configs are built into the module
   - Not customizable without forking the module
   - Workaround: Fork module and modify `config/` files

5. **Root Volume Only**
   - No support for additional EBS volumes
   - Only root volume is managed
   - Workaround: Create additional volumes with separate `aws_ebs_volume` resources

6. **No Backup Management**
   - No built-in snapshot/backup functionality
   - No automated AMI creation
   - Workaround: Use AWS Backup or separate backup solution

### Known Issues

- ⚠️ Auto-generated docs section may be outdated (regenerate with `terraform-docs`)
- ⚠️ FreeBSD SSM agent installation may fail on first boot (requires manual retry)
- ⚠️ Flatcar SSM agent requires Docker, which may take time to initialize

### Roadmap / Future Enhancements

- [ ] Support for additional EBS volumes
- [ ] Configurable cloud-init via variables
- [ ] Per-instance security group support
- [ ] Automated backup/snapshot configuration
- [ ] Support for Elastic IPs
- [ ] Load balancer target group attachment
- [ ] Auto Scaling Group variant

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    VPC (vpc_id)                         │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │         Subnet (subnet_id)                      │   │
│  │                                                 │   │
│  │  ┌──────────────────────────────────────────┐  │   │
│  │  │       EC2 Instance/s (name)              │  │   │
│  │  │                                          │  │   │
│  │  │  ┌────────────────────────────────┐     │  │   │
│  │  │  │  Selected AMI (os_family)      │     │  │   │
│  │  │  │  - debian / ubuntu / freebsd   │     │  │   │
│  │  │  │  - flatcar                     │     │  │   │
│  │  │  │  Architecture: amd64 / arm64   │     │  │   │
│  │  │  └────────────────────────────────┘     │  │   │
│  │  │                                          │  │   │
│  │  │  Security Group (allow_ssh_ips)         │◄─┼───┼── SSH from specified IPs
│  │  │  IAM Instance Profile + Role             │  │   │
│  │  │  Cloud-init (bootstrap + config)        │  │   │
│  │  │  Root Volume (gp3, configurable size)   │  │   │
│  │  └──────────────────────────────────────────┘  │   │
│  │                      │                          │   │
│  │                      │ Internet Access          │   │
│  └──────────────────────┼──────────────────────────┘   │
│                         │                              │
│                    ┌────▼────┐                         │
│    Public:         │   IGW   │                         │
│    Private:        └─────────┘                         │
│                    or                                  │
│                    ┌─────────┐                         │
│                    │   NAT   │                         │
│                    └─────────┘                         │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
                  AWS Services
                  - SSM (Session Manager) ◄── enable_ssm
                  - EC2 API
                  - CloudWatch Logs
```

### Component Overview

- **VPC/Subnet**: Provided by user, must have appropriate routing
- **EC2 Instances**: Created with `for_each` loop based on `instances`
- **Security Group**: Shared across all instances, SSH ingress + all egress
- **IAM Role**: Shared role with SSM policy (if `enable_ssm` is true)
- **AMI Selection**: Automatic based on `os_family` and `os_arch`
- **Cloud-init**: OS-specific bootstrap on first launch
- **SSH Key Pair**: Auto-generated (optional, controlled by `create_ssh_key`)

---

## Important Notes

- **Instance Recreation**: Changing the `name` field in `instances` will cause the instance to be destroyed and recreated
- **Metadata Security**: IMDSv2 is enforced for enhanced security (`http_tokens = "required"`)
- **Volume Management**: Root volumes are configured with gp3 (General Purpose SSD) and are deleted on instance termination
- **IAM Roles**: A shared IAM role and instance profile are created for all instances using the `name` variable
- **Spot Instances**: When enabled, instances use the `stop` interruption behavior to preserve data during spot interruptions

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

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
| [aws_ami.flatcar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.freebsd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudinit_config.debian](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [cloudinit_config.flatcar](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [cloudinit_config.freebsd](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [cloudinit_config.ubuntu](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instances_map"></a> [instances\_map](#input\_instances\_map) | Map of instances to create.<br>The map accepts an "instance" object as defined in variables.tf<br>Example:<br>[<br>  {<br>    name = "web.example.com",<br>    instance\_type = "t3.micro",<br>    disable\_api\_termination = false<br>    volume\_size = 10<br>    public = true<br>  },<br>  {<br>    name = "db.example.com",<br>    instance\_type = "t3.large",<br>    disable\_api\_termination = false<br>    volume\_size = 20<br>    public = false<br>  }<br>] | <pre>list(object({<br>    name                    = string<br>    instance_type           = string<br>    disable_api_termination = bool<br>    volume_size             = number<br>    public                  = bool<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | Name for the instance pool.<br>IAM roles for the instance/s will be created with this variable. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet where the resources will be created | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC where the resources will be created | `string` | n/a | yes |
| <a name="input_allow_ssh_ips"></a> [allow\_ssh\_ips](#input\_allow\_ssh\_ips) | List IP address that will be allowed to SSH into the box.<br>Format is "123.123.123.123/32" | `list(string)` | <pre>[<br>  "192.168.1.1/32"<br>]</pre> | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | If true, will associate a public ip address with the created instance | `bool` | `false` | no |
| <a name="input_aws_ssm_enabled"></a> [aws\_ssm\_enabled](#input\_aws\_ssm\_enabled) | If true, enables AWS Session Manager for connecting to the instance | `bool` | `true` | no |
| <a name="input_create_key"></a> [create\_key](#input\_create\_key) | Create an SSH key for connecting to the EC2 instace | `bool` | `true` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the SSH key pair to create for connecting to EC2 instances | `string` | `"Autogenerated terraform key for the tofu-modules/ec2"` | no |
| <a name="input_os_arch"></a> [os\_arch](#input\_os\_arch) | Processor architecture, possible options:<br>- amd64<br>- arm64 | `string` | `"amd64"` | no |
| <a name="input_os_family"></a> [os\_family](#input\_os\_family) | The flavor for the EC2 instance to be deployed, possible options:<br>  - debian<br>  - ubuntu<br>  - freebsd<br>  - flatcar | `string` | `"debian"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the AWS provider will be configured and deployed | `string` | `"us-east-1"` | no |
| <a name="input_spot_enabled"></a> [spot\_enabled](#input\_spot\_enabled) | If true, the instance will be a spot-instance | `bool` | `false` | no |
| <a name="input_spot_price"></a> [spot\_price](#input\_spot\_price) | The maximum hourly price that you're willing to pay for a Spot Instance | `number` | `0.005` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | ID of the AMI used for the instances |
| <a name="output_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#output\_iam\_instance\_profile\_name) | Name of the IAM instance profile attached to the instances |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role created for the instances |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the IAM role created for the instances |
| <a name="output_instance_arns"></a> [instance\_arns](#output\_instance\_arns) | Map of instance ARNs |
| <a name="output_instance_info"></a> [instance\_info](#output\_instance\_info) | Map of instance information including IDs, IP addresses, and instance types for all created instances |
| <a name="output_key_pair_name"></a> [key\_pair\_name](#output\_key\_pair\_name) | Name of the SSH key pair (null if create\_key is false) |
| <a name="output_private_key"></a> [private\_key](#output\_private\_key) | The auto-generated SSH private key in OpenSSH format for connecting to instances (sensitive) |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group created for SSH access |
<!-- END_TF_DOCS -->
