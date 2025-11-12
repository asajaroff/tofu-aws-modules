# EC2 Module - Code Notes

Quick reference for code improvements, problems, and important things to remember.

## Critical Issues (Fix First)

### 1. Spot Instance Hardcoded Price
**Location**: `main.tf:26`
**Problem**: `max_price = 0.005` is hardcoded instead of using `var.spot_price`
**Impact**: Variable `spot_price` exists but is never used
**Fix**: Change to `max_price = var.spot_price`

### 2. Cloud-init Only Works for Debian
**Location**: `main.tf:9`, `cloudinit.tf:1`
**Problem**: Always uses `data.cloudinit_config.debian` regardless of `os_family` setting
**Impact**: Ubuntu and FreeBSD instances get Debian bootstrap scripts
**Fix**: Make cloud-init conditional based on `os_family` variable

### 3. IAM SSM Policy Always Attached
**Location**: `iam.tf:20-23`
**Problem**: SSM policy attached even when `aws_ssm_enabled = false`
**Impact**: Grants unnecessary permissions, security concern
**Fix**: Add conditional: `count = var.aws_ssm_enabled ? 1 : 0`

### 4. Debian 13 AMI May Not Exist
**Location**: `data.tf:22`
**Problem**: Looking for `debian-13-*` but Debian 13 may not be released/available
**Impact**: AMI lookup may fail
**Action**: Verify Debian 13 availability or revert to Debian 12

## Important Problems (Fix Soon)

### 5. Variable Type Inconsistencies
**Location**: `variables.tf`
**Problems**:
- `spot_enabled` is `string` should be `bool`
- `aws_ssm_enabled` is `string` should be `bool`

**Impact**: Type confusion, potential validation issues

### 6. Instance Name Changes Cause Recreation
**Location**: `main.tf:3`
**Problem**: Uses `instance.name` as `for_each` key
**Impact**: Renaming instances destroys and recreates them (data loss risk)
**Consider**: Add lifecycle rule or use different key strategy

### 7. Missing Key Variable Documentation
**Location**: `variables.tf:124`
**Problem**: `key_name` description says "Create an SSH key" but it's the name, not a boolean
**Fix**: Update description to clarify it's the name of the key pair

## Recent Improvements (Already Fixed)

### ✓ Key Pair Conditional Creation
- Now properly respects `create_key` variable with `count`
- Both `tls_private_key` and `aws_key_pair` have proper conditionals

### ✓ Spot Instance Interruption Behavior
- Added missing quotes to `"stop"` value
- Was causing syntax errors

### ✓ Private Key Output Handling
- Returns `null` when `create_key = false`
- Prevents errors when key isn't created

### ✓ Security Group Naming
- Now uses `pool_name` for uniqueness
- Supports multiple module deployments in same VPC

### ✓ Multiple SSH IPs Support
- Changed from single `allow_ssh_ip` to `allow_ssh_ips` list
- Uses `for_each` to create multiple ingress rules

## Code Quality Issues

### 8. Commented IPv6 Code
**Location**: `security_groups.tf:22-28, 36-40`
**Issue**: IPv6 rules commented out
**Decision needed**: Remove or make conditional with variable

### 9. Security Group Name Has Space
**Location**: `security_groups.tf:3`
**Issue**: `"${var.pool_name} SSH ingress rule"` contains space
**Impact**: AWS resource names with spaces can cause CLI/API issues
**Suggestion**: Use hyphen or underscore: `"${var.pool_name}-ssh-ingress"`

### 10. Leftover Comments
**Location**: `security_groups.tf:43-46`
**Issue**: Comments about IP detection methods no longer used
**Action**: Clean up or document why they're kept

### 11. Inconsistent Resource Naming
- IAM role: `"${var.pool_name}-ec2-role"` (hyphen)
- IAM profile: `"${var.pool_name}-iam-instance-profile"` (hyphen)
- Security group name: `"${var.pool_name} SSH ingress rule"` (space)
- Security group tag: `"${var.pool_name}_ssh"` (underscore)

**Recommendation**: Standardize on hyphens

## Missing Outputs

The module could expose more useful information:
- Security group ID
- IAM role ARN and name
- Key pair name
- AMI ID used
- Instance ARNs

## Notable Design Decisions (Remember!)

### 1. Instance Map Structure
```hcl
for_each = { for instance in var.instances_map : instance.name => instance }
```
- Uses instance **name** as the key
- Changing names triggers recreation
- Names must be unique across the map

### 2. Shared Resources
- **One** IAM role for all instances (identified by `pool_name`)
- **One** security group for all instances
- **One** SSH key pair for all instances (if `create_key = true`)

### 3. AMI Selection Logic
```hcl
local.selected_ami = var.os_family == "debian" ? ... : (var.os_family == "freebsd" ? ... : ...)
```
- Nested ternary: Debian → FreeBSD → Ubuntu (default)
- All three AMIs are **always** queried (data sources execute regardless)

### 4. Key Algorithm
Uses **ED25519** instead of RSA - modern, secure, shorter keys

### 5. Spot Instance Behavior
When enabled:
- Applies to **ALL** instances in the pool (not per-instance)
- Uses `"stop"` interruption behavior (preserves data)
- Still needs `max_price` fix to use variable

### 6. Security Model
- IMDSv2 enforced (`http_tokens = "required"`)
- Default SSH allowed IP: `192.168.1.1/32` (placeholder - must be changed)
- Egress: allows all traffic
- No ingress rules except SSH

## Variable Defaults to Review

| Variable | Default | Note |
|----------|---------|------|
| `allow_ssh_ips` | `["192.168.1.1/32"]` | **Placeholder** - user must change |
| `spot_price` | `0.005` | Reasonable but unused (hardcoded in main.tf) |
| `aws_ssm_enabled` | `true` | Good default |
| `create_key` | `true` | Convenient for testing |
| `os_family` | `"debian"` | Reasonable |
| `os_arch` | `"amd64"` | Most common |
| `region` | `"us-east-1"` | Standard |

## Security Considerations

### Current Security Posture
✓ IMDSv2 enforced
✓ SSH key generation automated
✓ Security groups properly scoped
✓ SSM access enabled by default (good)
✗ Default SSH IP is placeholder (security risk if not changed)
✗ No EBS encryption enabled
✗ SSM policy attached even when disabled

### Recommendations
1. Consider making `allow_ssh_ips` required (no default)
2. Add EBS encryption with KMS key support
3. Fix SSM policy conditional attachment
4. Add variable validation for CIDR blocks
5. Consider adding security group rules for common patterns

## Testing Checklist

Before deploying changes:
- [ ] Run `tofu validate`
- [ ] Run `tofu fmt -check`
- [ ] Test with `os_family = "debian"`
- [ ] Test with `os_family = "ubuntu"`
- [ ] Test with `os_family = "freebsd"`
- [ ] Test with `create_key = false`
- [ ] Test with `spot_enabled = true`
- [ ] Test with `aws_ssm_enabled = false`
- [ ] Test with multiple instances
- [ ] Verify IAM permissions
- [ ] Check security group rules created correctly

## Quick Wins (Easy Improvements)

1. Fix `max_price` to use `var.spot_price` (1 line)
2. Fix variable types for `spot_enabled` and `aws_ssm_enabled` (2 lines)
3. Add SSM policy conditional (1 line)
4. Clean up commented IPv6 code (decision + delete)
5. Standardize resource naming (3-4 lines)
6. Add more outputs (10 lines)

## Breaking Changes to Consider

If implementing these fixes in a new version:

**Major Version (2.0.0)**:
- Variable type changes (`spot_enabled`, `aws_ssm_enabled`)
- Security group naming standardization
- Remove unused commented code

**Minor Version (1.1.0)**:
- Add outputs
- Add EBS encryption support
- Add lifecycle rules

**Patch Version (1.0.2)**:
- Fix `max_price` hardcoding
- Fix SSM conditional
- Fix cloud-init selection
- Update Debian version

## Documentation Status

| Document | Status | Notes |
|----------|--------|-------|
| README.md | ✓ Good | Examples and usage clear |
| CHANGELOG.md | ✓ Created | Comprehensive history |
| AGENTS.md | ✓ Created | AI assistant instructions |
| TODO.md | ✓ Detailed | 20+ items cataloged |
| CODE_NOTES.md | ✓ This file | Quick reference |

## Related Files to Check

When making changes, also review:
- `config/bootstrap-debian.sh` - Debian initialization script
- `config/cloud-config-debian.yaml` - Debian cloud-init config
- `Makefile` - Build and test automation
- `default.tfvars` - Example values
- Root `CHANGELOG` - Project-level changes

## Known Upstream Issues

None currently tracked. Monitor:
- AWS provider updates (~> 5.0)
- Terraform/OpenTofu compatibility
- AMI availability for all OS families
