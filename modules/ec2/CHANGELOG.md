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

### Changed
- Changed security group naming to use `pool_name` for uniqueness and multi-module deployment support
- Changed `allow_ssh_ip` (string) to `allow_ssh_ips` (list) to support multiple IP addresses
- Removed unused `local-exec` provisioner with `dig` command from security group
- Standardized all resource naming to use hyphens consistently

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
