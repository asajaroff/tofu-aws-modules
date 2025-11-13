# Changelog

All notable changes to the EC2 module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Added AGENTS.md with instructions for AI assistants working with this module
- Added CODE_NOTES.md with comprehensive code improvements, problems, and notable changes reference
- Added comprehensive TODO.md documenting known issues and planned improvements
- Added cloud-init configurations for Ubuntu (`bootstrap-ubuntu.sh`, `cloud-config-ubuntu.yaml`)
- Added cloud-init configurations for FreeBSD (`bootstrap-freebsd.sh`, `cloud-config-freebsd.yaml`)
- Added cloud-init configurations for Flatcar Container Linux (`bootstrap-flatcar.sh`, `cloud-config-flatcar.yaml`)
- Added support for Flatcar Container Linux as a new `os_family` option
- Added Flatcar AMI data source using official Flatcar owner ID (075585003325)
- Added architecture-aware AMI filtering for Flatcar (x86_64/arm64)
- Added container-based SSM agent deployment for Flatcar instances
- Added 7 new outputs for better module integration:
  - `security_group_id` - ID of the SSH security group
  - `iam_role_name` - Name of the IAM role
  - `iam_role_arn` - ARN of the IAM role
  - `iam_instance_profile_name` - Name of the IAM instance profile
  - `key_pair_name` - Name of the SSH key pair (or null)
  - `ami_id` - ID of the selected AMI
  - `instance_arns` - Map of instance ARNs
- Added `allow_ssh_ipv6_ips` variable for IPv6 SSH access control with default empty list (no IPv6 SSH by default)
- Added IPv6 SSH security group rules that iterate over custom addresses (consistent with IPv4 pattern)
- Added `disable_api_termination` implementation to EC2 instances (was defined in variables but not applied)
- Added tags to IAM role, IAM instance profile, SSH key pair, and security group for better resource management
- Added map-based AMI selection logic for cleaner code (`ami_map` in data.tf)
- Added map-based cloudinit selection logic for cleaner code (`cloudinit_map` in cloudinit.tf)

### Changed - BREAKING
- **BREAKING**: Renamed `pool_name` variable to `name` for clearer purpose and simpler naming
- **BREAKING**: Renamed `instances_map` variable to `instances` (it was always a list, not a map)
- **BREAKING**: Renamed `create_key` variable to `create_ssh_key` for consistency and clarity
- **BREAKING**: Renamed `aws_ssm_enabled` variable to `enable_ssm` for consistent naming pattern
- **BREAKING**: Renamed `key_name` variable to `ssh_key_name` for specificity
- **BREAKING**: Removed unused `associate_public_ip_address` variable (functionality already available via `instances[].public`)
- **BREAKING**: Changed IPv6 SSH access from open `::/0` to custom list via `allow_ssh_ipv6_ips` (secure by default)
- **BREAKING**: Renamed `key_pair_name` output to `ssh_key_name` for consistency
- **BREAKING**: Renamed security group resource from `allow_ssh` to `instance` (reflects broader purpose)

### Changed - Non-Breaking
- Changed security group naming to use `pool_name` for uniqueness and multi-module deployment support
- Changed `allow_ssh_ip` (string) to `allow_ssh_ips` (list) to support multiple IP addresses
- Removed unused `local-exec` provisioner with `dig` command from security group
- Standardized all resource naming to use hyphens consistently
- Improved security group resource naming:
  - `allow_ssh_ipv4` → `ssh_ipv4`
  - `allow_ssh_ipv6` → `ssh_ipv6`
  - `allow_high_ports_ipv6` → `high_ports_tcp_ipv6`
  - `allow_high_ports_udp_ipv6` → `high_ports_udp_ipv6`
  - `allow_all_traffic_ipv4` → `all_ipv4`
  - `allow_all_traffic_ipv6` → `all_ipv6`
- Improved security group description from "Allow SSH inbound traffic..." to "Security group for EC2 instances"
- Improved security group naming from `${var.name}-ssh-ingress` to `${var.name}-sg`
- Improved IAM resource naming:
  - Instance profile: `${var.name}-iam-instance-profile` → `${var.name}-instance-profile`
  - Policy attachment: `custom` → `ssm` (clearer purpose)
- Simplified AMI selection logic from nested ternaries to map lookup for better readability
- Simplified cloudinit selection logic from nested ternaries to map lookup for better readability
- Improved comments in iam.tf for clarity (e.g., "Attach SSM policy to role for Session Manager access")
- Standardized boolean checks (removed redundant `== true` comparisons)
- Changed empty string returns to `null` for optional values (e.g., `key_name` when SSH key not created)
- Updated main.tf tags format from single-line to multi-line for better readability
- Improved default value for `ssh_key_name` from verbose string to concise "terraform-ec2-module-key"

### Fixed
- Fixed key pair conditional creation - now properly respects `create_key` variable
- Fixed spot instance `instance_interruption_behavior` - added missing quotes to `"stop"` value
- Fixed `private_key` output to return null when `create_key` is false (prevents errors)
- Fixed key pair reference to use index `[0]` for conditional resource
- Fixed spot instance pricing - now uses `var.spot_price` instead of hardcoded `0.005`
- Fixed cloud-init configuration - now conditional based on `os_family` (Debian, Ubuntu, or FreeBSD)
- Fixed IAM SSM policy attachment - now conditional based on `aws_ssm_enabled` variable
- Fixed security group name - removed space, now uses `${var.pool_name}-ssh-ingress`
- Fixed security group tag naming - standardized to use hyphens `${var.pool_name}-ssh`
- Fixed variable types - `spot_enabled` and `aws_ssm_enabled` changed from `string` to `bool`
- Fixed `key_name` variable description to clarify it's the SSH key pair name
- Fixed `disable_api_termination` - now actually applied to instances (was only defined in variables)
- Fixed inconsistent output descriptions to reference new variable names

### Improved
- Improved README.md documentation with all new variable names and examples
- Improved variable descriptions for clarity and consistency
- Improved output descriptions for accuracy
- Updated all examples in `examples/custom-cloud-init/` with new variable names
- Updated architecture diagrams to reflect new naming conventions
- Improved code organization and readability throughout module
- Improved custom cloud-config documentation for consistency

### Security
- **SECURITY**: Changed default IPv6 SSH behavior from open (`::/0`) to closed (empty list) - must explicitly allow IPv6 addresses
- **SECURITY**: IPv6 SSH now requires explicit address whitelisting via `allow_ssh_ipv6_ips` variable

### Verified
- Verified Debian 13 (Trixie) AMI availability and naming pattern compatibility

## [1.0.1] - 2025-10-12

### Added
- Re-added `private_key` output for SSH access
- Added comprehensive TODO documentation

### Changed
- Improved README with better examples and documentation
- Refactored module structure for better maintainability

## [1.0.0] - 2024-09-22

### Added
- Initial EC2 module release
- Support for multiple operating systems (Debian, Ubuntu, FreeBSD)
- Support for multiple architectures (amd64, arm64)
- Spot instance support with configurable pricing
- Automated SSH key pair generation and management
- IAM role and instance profile creation
- AWS Session Manager (SSM) integration
- Cloud-init based instance initialization
- Security group management with SSH access control
- Configurable root volume size per instance
- Multi-instance deployment from single module call
- IMDSv2 enforcement for enhanced security
- Support for public and private instances

### Fixed
- Fixed variable type for `public` field in `instances_map` from hardcoded `true` to proper `bool`
- Fixed example documentation with correct instance names and volume_size

## [0.1.0] - 2024-09-01 (Initial Development)

### Added
- Basic EC2 instance provisioning
- AMI selection logic for different OS families
- Basic security group configuration
- Instance profile integration
- Cloud-init configuration for Debian
- Makefile for common operations
- Initial documentation

[Unreleased]: https://github.com/asajaroff/tofu-aws-modules/compare/ec2-v1.0.1...HEAD
[1.0.1]: https://github.com/asajaroff/tofu-aws-modules/compare/ec2-v1.0.0...ec2-v1.0.1
[1.0.0]: https://github.com/asajaroff/tofu-aws-modules/releases/tag/ec2-v1.0.0
