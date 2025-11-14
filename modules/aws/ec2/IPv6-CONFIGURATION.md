# IPv6 Configuration Guide

This guide explains how to properly configure IPv6 for EC2 instances in this module.

## Overview

By default, IPv6 is **disabled** in this module to avoid connectivity issues when VPC infrastructure isn't properly configured. This prevents problems like:
- NAT64 synthetic addresses (64:ff9b::/96) that don't work
- DNS timeouts when trying to reach external services
- SSH/Git operations failing after 30-60 second timeouts

## Quick Start - Disable IPv6 (Recommended for Most Users)

The module defaults are already set to disable IPv6:

```hcl
module "ec2" {
  source = "../../modules/ec2"

  # IPv6 is disabled by default - no configuration needed
  # enable_ipv6               = false  # Default
  # enable_ipv6_security_rules = false  # Default

  # ... other configuration ...
}
```

## Enabling IPv6 (Advanced)

If you need IPv6, you must ensure your AWS infrastructure is properly configured first.

### Prerequisites

Before enabling IPv6, verify your VPC has:

1. **IPv6 CIDR Block assigned to VPC**
   ```bash
   aws ec2 describe-vpcs --vpc-ids <your-vpc-id> --query 'Vpcs[0].Ipv6CidrBlockAssociationSet'
   ```

2. **IPv6 CIDR Block assigned to Subnet**
   ```bash
   aws ec2 describe-subnets --subnet-ids <your-subnet-id> --query 'Subnets[0].Ipv6CidrBlockAssociationSet'
   ```

3. **Internet Gateway or Egress-Only Internet Gateway**
   ```bash
   aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=<your-vpc-id>"
   ```

4. **Route Table with IPv6 routes**
   ```bash
   aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=<your-subnet-id>" --query 'RouteTables[0].Routes'
   ```
   Look for a route with: `DestinationIpv6CidrBlock: ::/0`

### Configuration

Once infrastructure is ready, enable IPv6:

```hcl
module "ec2" {
  source = "../../modules/ec2"

  # Enable IPv6
  enable_ipv6                = true
  enable_ipv6_security_rules = true  # Required when enable_ipv6 is true
  ipv6_address_count         = 1     # Number of IPv6 addresses per instance

  # Optional: Allow IPv6 SSH access
  allow_ssh_ipv6_ips = [
    "2001:db8::/32",  # Your IPv6 CIDR
  ]

  # ... other configuration ...
}
```

## Troubleshooting NAT64 Issues

### Symptom
```
DNS returns: 64:ff9b::8c52:7903 (NAT64 synthetic address)
100% packet loss
Git/SSH operations timeout after 30-60 seconds
IPv4 works perfectly
```

### Solution 1: Disable IPv6 (Recommended)
Set `enable_ipv6 = false` in your module configuration.

### Solution 2: Fix VPC Infrastructure

If you need IPv6, fix the underlying infrastructure:

#### Option A: Add Egress-Only Internet Gateway
```hcl
resource "aws_egress_only_internet_gateway" "this" {
  vpc_id = var.vpc_id
}

resource "aws_route" "ipv6_egress" {
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this.id
}
```

#### Option B: Use Internet Gateway (for public subnets)
```hcl
resource "aws_route" "ipv6_internet" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}
```

### Solution 3: Force IPv4 on the Instance

If you can't disable IPv6 at the infrastructure level, configure the instance to prefer IPv4:

```bash
# Add to your bootstrap script or user_data
echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf

# Or disable IPv6 entirely
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

## Security Considerations

When `enable_ipv6_security_rules = true`, the following rules are created:

### Ingress Rules
- **SSH (port 22)**: Only from specified IPv6 addresses (via `allow_ssh_ipv6_ips`)
- **High ports (10000-65535)**: TCP and UDP from `::/0` for return traffic and applications
- **Blocked**: All incoming traffic on ports 1-9999 (except SSH if configured)

### Egress Rules
- **All traffic** to `::/0` (unrestricted outbound to all IPv6 destinations)

This configuration provides:
- ✅ Outbound connectivity for package updates, git cloning, API calls, etc.
- ✅ Return traffic for established connections on high ports
- ✅ Protection against unauthorized inbound connections on low ports
- ✅ Controlled SSH access from specific IPv6 addresses

## Testing IPv6 Connectivity

After enabling IPv6, test connectivity from your instance:

```bash
# Check if IPv6 address is assigned
ip -6 addr show

# Test IPv6 connectivity
ping6 -c 4 2600::

# Test DNS over IPv6
dig @2001:4860:4860::8888 google.com AAAA

# Test git over IPv6
ssh -6 -T git@github.com
```

## Module Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `enable_ipv6` | bool | false | Enable IPv6 address assignment |
| `ipv6_address_count` | number | 1 | Number of IPv6 addresses per instance |
| `enable_ipv6_security_rules` | bool | false | Enable IPv6 security group rules |
| `allow_ssh_ipv6_ips` | list(string) | [] | IPv6 addresses allowed for SSH |

## References

- [AWS VPC IPv6 Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ipv6.html)
- [NAT64 and DNS64](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-nat64-dns64.html)
- [EC2 IPv6 Addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#ipv6-addressing)
