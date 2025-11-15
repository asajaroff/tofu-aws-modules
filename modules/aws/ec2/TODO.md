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

### 18. Additional EBS Volumes with Custom Mount Points
**Status**: Design Complete - Ready for Implementation

**Description**: Add support for additional EBS volumes with automatic formatting, mounting, and persistence across reboots.

#### New Files to Create:
- `ebs.tf` - EBS volume and attachment resources
- `config/mount-ebs.sh.tpl` - Template script for mounting volumes

#### Files to Modify:
- `variables.tf` - Add `additional_ebs_volumes` variable
- `cloudinit.tf` - Include EBS mounting script in cloud-init for all OS families
- `data.tf` - Add subnet data source (if not exists)
- `outputs.tf` - Add EBS volume outputs

#### Variable Definition (`variables.tf`):
```hcl
variable "additional_ebs_volumes" {
  type = list(object({
    device_name           = string
    volume_size          = number
    volume_type          = string
    iops                 = optional(number)
    throughput           = optional(number)
    encrypted            = optional(bool, true)
    kms_key_id           = optional(string)
    delete_on_termination = optional(bool, true)
    mount_point          = string
    filesystem_type      = optional(string, "ext4")
  }))
  default     = []
  description = <<EOT
List of additional EBS volumes to attach to instances.
Example:
[
  {
    device_name  = "/dev/sdf"
    volume_size  = 100
    volume_type  = "gp3"
    iops         = 3000
    throughput   = 125
    encrypted    = true
    mount_point  = "/data"
    filesystem_type = "ext4"
  }
]
EOT
}
```

#### Resource Configuration (`ebs.tf`):
```hcl
# Create additional EBS volumes
resource "aws_ebs_volume" "additional" {
  for_each = {
    for idx, vol in var.additional_ebs_volumes :
    "${idx}" => vol
  }

  availability_zone = data.aws_subnet.selected.availability_zone
  size              = each.value.volume_size
  type              = each.value.volume_type
  iops              = each.value.iops
  throughput        = each.value.throughput
  encrypted         = each.value.encrypted
  kms_key_id        = each.value.kms_key_id

  tags = merge(
    {
      Name = "${var.pool_name}-ebs-${each.key}"
    },
    var.tags
  )
}

# Attach volumes to instances
resource "aws_volume_attachment" "additional" {
  for_each = {
    for pair in flatten([
      for instance_key, instance in var.instances_map : [
        for vol_idx, vol in var.additional_ebs_volumes : {
          key         = "${instance_key}-${vol_idx}"
          instance_id = aws_instance.this[instance_key].id
          volume_id   = aws_ebs_volume.additional[tostring(vol_idx)].id
          device_name = vol.device_name
        }
      ]
    ]) : pair.key => pair
  }

  device_name = each.value.device_name
  volume_id   = each.value.volume_id
  instance_id = each.value.instance_id
}
```

#### Mount Script Template (`config/mount-ebs.sh.tpl`):
```bash
#!/bin/bash
set -e

echo "Mounting additional EBS volumes..."

%{~ for vol in volumes ~}
# Mount ${vol.mount_point}
echo "Processing ${vol.device_name} -> ${vol.mount_point}"

# Wait for device to be available
for i in {1..30}; do
  if [ -b "${vol.device_name}" ]; then
    echo "Device ${vol.device_name} is available"
    break
  fi
  echo "Waiting for device ${vol.device_name}... ($i/30)"
  sleep 2
done

# Create mount point
mkdir -p ${vol.mount_point}

# Check if device has a partition
if ! blkid ${vol.device_name}1 > /dev/null 2>&1; then
  echo "Creating partition and filesystem on ${vol.device_name}"
  parted -s ${vol.device_name} mklabel gpt
  parted -s ${vol.device_name} mkpart primary 0% 100%
  sleep 2
  mkfs.${vol.filesystem_type} ${vol.device_name}1
else
  echo "Filesystem already exists on ${vol.device_name}1"
fi

# Mount the volume
if ! mountpoint -q ${vol.mount_point}; then
  mount ${vol.device_name}1 ${vol.mount_point}
  echo "Mounted ${vol.device_name}1 to ${vol.mount_point}"
fi

# Add to fstab if not already there
if ! grep -q "${vol.device_name}1" /etc/fstab; then
  echo "${vol.device_name}1 ${vol.mount_point} ${vol.filesystem_type} defaults,nofail 0 2" >> /etc/fstab
  echo "Added ${vol.device_name}1 to /etc/fstab"
fi

%{~ endfor ~}

echo "All EBS volumes mounted successfully"
```

#### Updated Cloud-init (`cloudinit.tf`):
Update each OS family's cloudinit_config to include the mount script:
```hcl
data "cloudinit_config" "debian" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "bootstrap-debian.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/config/bootstrap-debian.sh")
  }

  part {
    filename     = "mount-ebs.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/config/mount-ebs.sh.tpl", {
      volumes = var.additional_ebs_volumes
    })
  }

  part {
    filename     = "bootstrap.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/config/cloud-config-debian.yaml")
  }
}
# Repeat for ubuntu, freebsd, and flatcar
```

#### Data Source (`data.tf`):
```hcl
data "aws_subnet" "selected" {
  id = var.subnet_id
}
```

#### New Outputs (`outputs.tf`):
```hcl
output "ebs_volume_ids" {
  description = "Map of additional EBS volume IDs"
  value = {
    for idx, vol in aws_ebs_volume.additional :
    idx => vol.id
  }
}

output "ebs_volume_arns" {
  description = "Map of additional EBS volume ARNs"
  value = {
    for idx, vol in aws_ebs_volume.additional :
    idx => vol.arn
  }
}
```

#### Usage Example:
```hcl
module "ec2_with_storage" {
  source = "./modules/ec2"

  pool_name  = "web-servers"
  vpc_id     = "vpc-12345"
  subnet_id  = "subnet-67890"

  instances_map = [
    {
      name                    = "web-01.example.com"
      instance_type           = "t3.large"
      disable_api_termination = false
      volume_size            = 20
      public                 = true
    }
  ]

  additional_ebs_volumes = [
    {
      device_name     = "/dev/sdf"
      volume_size     = 100
      volume_type     = "gp3"
      iops            = 3000
      throughput      = 125
      encrypted       = true
      mount_point     = "/data"
      filesystem_type = "ext4"
    },
    {
      device_name     = "/dev/sdg"
      volume_size     = 50
      volume_type     = "gp3"
      mount_point     = "/var/log/app"
      filesystem_type = "xfs"
    }
  ]
}
```

#### Features:
- ✅ Multiple additional EBS volumes per instance
- ✅ Custom mount points
- ✅ Configurable volume type (gp2, gp3, io1, io2)
- ✅ IOPS and throughput configuration for performance volumes
- ✅ Encryption support with optional KMS key
- ✅ Automatic partition creation
- ✅ Automatic filesystem creation (ext4, xfs, etc.)
- ✅ Automatic mounting on first boot
- ✅ Persistent mounts via /etc/fstab
- ✅ Device availability checking (waits up to 60 seconds)
- ✅ Idempotent - won't re-format existing filesystems
- ✅ Works across all OS families (Debian, Ubuntu, FreeBSD, Flatcar)

#### Implementation Checklist:
- [ ] Create `ebs.tf` with volume and attachment resources
- [ ] Create `config/mount-ebs.sh.tpl` template
- [ ] Add `additional_ebs_volumes` variable to `variables.tf`
- [ ] Update `cloudinit.tf` for all OS families (debian, ubuntu, freebsd, flatcar)
- [ ] Add `data.aws_subnet.selected` to `data.tf` (if not exists)
- [ ] Add EBS volume outputs to `outputs.tf`
- [ ] Test with single volume
- [ ] Test with multiple volumes
- [ ] Test with different filesystem types
- [ ] Test with encrypted volumes
- [ ] Test idempotency (rerunning doesn't break existing volumes)
- [ ] Update module README with usage examples

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
