# Agent Instructions for EC2 Module

This document provides context and guidelines for AI agents (like Claude) working with this OpenTofu/Terraform EC2 module.

## Module Overview

This is a flexible EC2 module for provisioning AWS instances with support for:
- Multiple OS families (Debian, Ubuntu, FreeBSD)
- Multiple architectures (amd64, arm64)
- Spot instances with configurable pricing
- Automated SSH key generation and management
- IAM role/profile integration
- AWS SSM (Session Manager) support
- Cloud-init based configuration
- Security group management with SSH access control

## File Structure

```
modules/ec2/
├── main.tf              # Core EC2 instance resource definitions
├── variables.tf         # Input variable definitions
├── outputs.tf           # Output definitions
├── data.tf              # Data source queries (AMI selection, VPC info)
├── iam.tf               # IAM role and instance profile resources
├── keys.tf              # SSH key pair generation
├── security_groups.tf   # Security group and rules
├── cloudinit.tf         # Cloud-init configuration
├── provider.tf          # Provider configuration
├── config/              # Cloud-init configuration templates
├── README.md            # User-facing documentation
└── TODO.md              # Outstanding tasks and issues
```

## Key Design Patterns

### Instance Management
- Uses `for_each` over `instances_map` variable to create multiple instances
- Instance names are used as keys in the for_each loop
- **Important**: Changing instance names will cause recreation of instances

### AMI Selection
- AMIs are selected dynamically via data sources in `data.tf`
- Selection is based on `os_family` and `os_arch` variables
- Uses latest available AMI matching the criteria

### Security Model
- IMDSv2 enforced (`http_tokens = "required"`) for metadata security
- Security groups allow SSH from specified IPs (`allow_ssh_ips` variable)
- Default SSH allowed IP is `192.168.1.1/32` - should always be customized
- Egress allows all traffic (standard practice)
- AWS SSM enabled by default for secure access without SSH

### IAM Configuration
- Shared IAM role created for all instances in the pool
- Role name derived from `pool_name` variable
- Instance profile attached to all instances
- Optional SSM policy attachment controlled by `aws_ssm_enabled`

## Common Tasks

### Adding New Variables
1. Define in `variables.tf` with type, description, and default (if applicable)
2. Use in appropriate resource files
3. Update README.md documentation (use terraform-docs)
4. Consider backward compatibility

### Modifying Instance Configuration
- Main instance resource is in `main.tf:2`
- Root block device configuration at `main.tf:14-18`
- Spot instance options at `main.tf:21-30`
- Metadata options at `main.tf:32-34`

### Security Group Changes
- Security group resource in `security_groups.tf`
- SSH ingress rules use `allow_ssh_ips` variable
- Consider impact on existing deployments

### Cloud-init Modifications
- Cloud-init configuration in `cloudinit.tf`
- Templates in `config/` directory
- Used for initial instance setup and software installation

## Important Constraints

### OpenTofu/Terraform Version Requirements
- Terraform/OpenTofu >= 1.1
- AWS Provider ~> 5.0

### AWS Resources Created
- EC2 instances (number matches `instances_map` length)
- IAM role and instance profile (one per module call)
- Security group (one per module call)
- SSH key pair (optional, controlled by `create_key`)

### State Considerations
- Changing instance names causes recreation
- IAM role name changes cause recreation
- Security group changes may cause brief downtime
- SSH private key stored in state (sensitive)

## Testing and Validation

### Before Making Changes
1. Read existing code to understand current implementation
2. Check `TODO.md` for known issues
3. Review recent git commits for context
4. Validate terraform/tofu syntax

### After Making Changes
1. Run `terraform validate` or `tofu validate`
2. Run `terraform fmt` or `tofu fmt` for formatting
3. Update documentation if needed (terraform-docs)
4. Test with `terraform plan` in a safe environment
5. Consider impact on existing deployments
6. Write a CHANGELOG comment with the modifications

### Available Make Targets
Check `Makefile` for available automation:
- Format checking
- Validation
- Documentation generation
- Planning and applying

## Common Pitfalls

1. **Instance Naming**: Changing `name` in `instances_map` recreates instances
2. **SSH Access**: Default `allow_ssh_ips` is placeholder, must be customized
3. **Spot Instances**: When enabled, affects ALL instances in the pool
4. **Key Management**: Private keys stored in state, handle with care
5. **Public IPs**: Controlled by `public` field in each instance config
6. **Volume Deletion**: Root volumes delete on termination by default

## Best Practices

### When Adding Features
- Follow existing patterns and conventions
- Keep backward compatibility when possible
- Add clear variable descriptions
- Update documentation
- Consider security implications

### When Fixing Bugs
- Understand the root cause before making changes
- Test in isolation when possible
- Document behavior changes
- Update TODO.md if related tasks exist

### When Refactoring
- Ensure no resource recreation unless intended
- Test state changes carefully
- Document migration paths if needed
- Consider existing users of the module

## Documentation Standards

- Use terraform-docs for automated documentation generation
- Keep README.md user-focused and example-driven
- Document all variables with clear descriptions
- Include usage examples for common scenarios
- Note any breaking changes or upgrade paths

## Security Considerations

Always consider:
- Least privilege for IAM roles
- Proper security group restrictions
- SSH key management
- IMDSv2 enforcement
- Public vs private instance placement
- VPC and subnet security

## Getting Help

- Review README.md for module usage
- Check TODO.md for known issues
- Examine recent commits for context
- Test changes in isolated environment
- Use terraform/tofu plan to preview changes

## Current Known Issues

Check `TODO.md` for the current list of known issues and planned improvements.
