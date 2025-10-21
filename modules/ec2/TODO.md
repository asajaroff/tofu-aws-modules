# EC2 Module TODO

This document tracks improvements and fixes for the EC2 module.

## Critical Issues (High Priority)

### 1. Fix Spot Instance Configuration
**File**: `main.tf:26-27`
- [ ] Change hardcoded `max_price = 0.005` to use `var.spot_price`
- [ ] Add quotes to `instance_interruption_behavior = "stop"`

**Current code:**
```hcl
max_price                      = 0.005
instance_interruption_behavior = stop
```

**Should be:**
```hcl
max_price                      = var.spot_price
instance_interruption_behavior = "stop"
```

### 2. Add Missing Variable Definition
**File**: `variables.tf`
- [ ] Add `allow_ssh_ip` variable definition (currently referenced in security_groups.tf but not defined)

### 3. Fix Key Pair Conditional Creation
**File**: `keys.tf:8-11`
- [ ] Add conditional logic to `aws_key_pair.this` resource
- [ ] Should only create key pair when `create_key = true`

**Current issue:** Key pair is always created even when `create_key = false`

### 4. Fix Cloud-init for Multiple OS Families
**File**: `main.tf:9`, `cloudinit.tf`
- [ ] Make cloud-init configuration dynamic based on `os_family` variable
- [ ] Create cloud-init configs for Ubuntu
- [ ] Create cloud-init configs for FreeBSD
- [ ] Currently only Debian cloud-init is used regardless of OS selection

### 5. Make IAM SSM Policy Conditional
**File**: `iam.tf:20-23`
- [ ] Only attach SSM policy when `aws_ssm_enabled = true`
- [ ] Add conditional logic to `aws_iam_role_policy_attachment.custom`

## Design Issues (Medium Priority)

### 6. Fix Resource Naming Conflicts
**File**: `security_groups.tf:3`
- [ ] Use `pool_name` in security group name for uniqueness
- [ ] Current hardcoded name `"allow_ssh_ec2"` will conflict if module is used multiple times

**Suggestion:**
```hcl
name = "${var.pool_name}-allow-ssh"
```

### 7. Fix Variable Type Inconsistencies
**File**: `variables.tf`
- [ ] Change `spot_enabled` from `string` to `bool`
- [ ] Change `aws_ssm_enabled` from `string` to `bool`

### 8. Add EBS Encryption Support
**File**: `main.tf:14-18`
- [ ] Add variable for EBS encryption (`ebs_encryption_enabled`)
- [ ] Add variable for KMS key ID (optional)
- [ ] Add encryption configuration to `root_block_device`

**Suggested addition:**
```hcl
root_block_device {
  volume_type           = "gp3"
  volume_size           = each.value.volume_size
  delete_on_termination = true
  encrypted             = var.ebs_encryption_enabled
  kms_key_id            = var.kms_key_id
}
```

### 9. Add Lifecycle Rules for Instance Names
**File**: `main.tf:2`
- [ ] Add lifecycle block to prevent recreation when names change
- [ ] Addresses TODO: "Changing names recreates instances"

**Suggested addition:**
```hcl
lifecycle {
  create_before_destroy = true
  ignore_changes        = [tags["Name"]]
}
```

### 10. Expand Module Outputs
**File**: `outputs.tf`
- [ ] Add security group ID output
- [ ] Add IAM role ARN output
- [ ] Add IAM role name output
- [ ] Add key pair name output
- [ ] Add AMI ID used output
- [ ] Add instance ARNs output

## Code Quality Issues (Medium Priority)

### 11. Remove Dead Code
**File**: `security_groups.tf:14-16`
- [ ] Remove unused `local-exec` provisioner with `dig` command
- [ ] Output is never captured or used

### 12. Update to Debian 13
**File**: `data.tf:22`
- [ ] Verify Debian 13 AMI availability and naming convention
- [ ] Test with actual Debian 13 images
- [ ] Update documentation

## Feature Enhancements (Low Priority)

### 13. Additional Security Group Support
- [ ] Add variable for additional security group IDs
- [ ] Allow attaching custom security groups alongside the default SSH group

**Suggested addition:**
```hcl
variable "additional_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Additional security groups to attach to instances"
}
```

### 14. Custom IAM Policy Support
- [ ] Add variable for additional IAM policy ARNs
- [ ] Allow attaching custom policies to the instance role

### 15. SSH Configuration Options
- [ ] Add option to disable SSH security group entirely (useful when only using SSM)
- [ ] Add support for multiple allowed CIDR blocks for SSH
- [ ] Add variable for custom SSH port

### 16. Custom User Data Support
- [ ] Add option to provide custom user_data
- [ ] Add option to merge custom user_data with default cloud-init
- [ ] Add template variables for user_data customization

### 17. Advanced EC2 Features
- [ ] Add support for placement groups
- [ ] Add support for multiple network interfaces
- [ ] Add support for Elastic IPs
- [ ] Add detailed monitoring option
- [ ] Add instance tenancy options (default/dedicated/host)
- [ ] Add CPU credits configuration for burstable instances (unlimited/standard)

### 18. Storage Enhancements
- [ ] Add support for additional EBS volumes
- [ ] Add volume type configuration (gp2, gp3, io1, io2, etc.)
- [ ] Add IOPS configuration for io1/io2 volumes
- [ ] Add throughput configuration for gp3 volumes

### 19. Monitoring and Backup
- [ ] Add EBS snapshot lifecycle policy
- [ ] Add backup tags for AWS Backup
- [ ] Add CloudWatch alarm configuration
- [ ] Add tags for monitoring tools integration

### 20. Network Configuration
- [ ] Add option for IPv6 support
- [ ] Add support for source/destination check configuration
- [ ] Add support for secondary private IPs

### 21. Cost Optimization
- [ ] Add support for instance hibernation
- [ ] Add support for capacity reservations
- [ ] Add better spot instance options (interruption behavior per instance)

## Documentation Improvements

### 22. Examples
- [ ] Create examples directory with sample configurations
- [ ] Add example for multi-region deployment
- [ ] Add example for auto-scaling integration
- [ ] Add example with custom IAM policies

### 23. Testing
- [ ] Add terraform validation tests
- [ ] Add integration tests
- [ ] Add example outputs

## Priority Summary

**Critical (Do First):**
1. Fix spot instance configuration (broken)
2. Add missing `allow_ssh_ip` variable
3. Fix key pair conditional creation
4. Fix cloud-init for Ubuntu/FreeBSD
5. Make IAM SSM policy conditional

**Important (Do Soon):**
6. Fix resource naming conflicts
7. Fix variable type inconsistencies
8. Add EBS encryption
9. Add lifecycle rules for names
10. Expand outputs

**Nice to Have (Do Later):**
11-21. Feature enhancements and additional capabilities

## Breaking Changes Notice

Some of these changes may introduce breaking changes:
- Variable type changes (spot_enabled, aws_ssm_enabled)
- Security group naming change
- Lifecycle rules addition

Consider versioning strategy when implementing.
