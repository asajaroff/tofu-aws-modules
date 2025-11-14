# AI Agent Guidelines

This document provides guidelines for AI coding agents working with this repository.

## Project Overview

This is a collection of OpenTofu/Terraform modules organized by cloud provider (AWS, Azure, DigitalOcean, GCP). These modules are designed for standalone usage or with wrapper tools such as Terragrunt.

## Project Structure

```
modules/
├── aws/           # AWS-specific modules
├── azure/         # Azure-specific modules
├── digitalocean/  # DigitalOcean-specific modules
└── gcp/           # GCP-specific modules
```

Each module contains:
- `main.tf` - Main resource definitions
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output value declarations
- `providers.tf` - Provider configurations
- `README.md` - Module documentation with input/output descriptions

## Key Principles

### 1. OpenTofu Over Terraform

**ALWAYS prefer OpenTofu over Terraform:**
- Use `.tf` file extensions for all modules
- Reference "tofu" or "opentofu" in documentation, not "terraform"
- Use `tofu` commands in examples and scripts
- The tool is OpenTofu, but files use standard `.tf` extension

### 2. Conventional Commits

This repository follows the [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0-beta.2/). All commits MUST adhere to this format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Common types:**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding or updating tests
- `chore`: Changes to build process or auxiliary tools

**Scope examples:**
- Module names: `feat(ec2): add support for instance metadata options`
- Provider names: `fix(digitalocean): correct VPC CIDR validation`
- Component names: `docs(cloudfront): update usage examples`

**Breaking changes:**
- Append `!` after type/scope: `feat(eip)!: change output variable names`
- Include `BREAKING CHANGE:` in commit body or footer

**Important commit restrictions:**
- Never mention "AI", "agent", "Claude", or any coding assistant references in commit messages
- Never add "Co-Authored-By: Claude" or similar attribution lines
- Never add generated-by links or badges to commit messages
- Keep commits professional and focused on the technical changes

### 3. Module Versioning & Tagging

Git tags follow semantic versioning with module prefix:

**Format:** `<module-path>/vX.Y.Z`

**Examples:**
- `ec2/v1.1.0`
- `cloudfront-s3-static-site/v1.0.0`
- `do-kubernetes/v1.0.0`

**Semantic Versioning:**
- **MAJOR** (X): Breaking changes that require user action
- **MINOR** (Y): New features, backwards-compatible
- **PATCH** (Z): Bug fixes, backwards-compatible

### 4. Module Development Workflow

**Creating a new module:**
```bash
mkdir -p modules/<provider>/<module-name>
cp module.Makefile modules/<provider>/<module-name>/Makefile
cd modules/<provider>/<module-name>
touch {main,variables,providers,outputs}.tf
```

**Common tasks:**
- Use the provided Makefile for linting, testing, and documentation generation
- Generate documentation automatically using terraform-docs
- Validate syntax with `tofu validate`
- Format code with `tofu fmt`

### 5. Code Quality Standards

**File organization:**
- Keep resource definitions in `main.tf`
- Declare all variables in `variables.tf` with descriptions
- Export outputs in `outputs.tf` with descriptions
- Configure providers in `providers.tf`

**Documentation:**
- Update module README.md with terraform-docs
- Include usage examples
- Document all inputs and outputs
- Explain module purpose and behavior

**Naming conventions:**
- Use lowercase with hyphens for module directories
- Use snake_case for resource names and variables
- Use descriptive names that indicate purpose

### 6. Testing & Validation

Before committing:
1. Run `tofu fmt -recursive` to format code
2. Run `tofu validate` to check syntax
3. Update documentation with terraform-docs
4. Test module with example configurations
5. Verify no sensitive data in code

## Common Operations

### Adding a Feature
```
feat(module-name): add support for new capability

- Implement resource configuration
- Add necessary variables
- Update outputs
- Regenerate documentation
```

### Fixing a Bug
```
fix(module-name): correct resource attribute handling

Fixes issue where attribute was not properly validated.
```

### Breaking Changes
```
feat(module-name)!: restructure outputs for consistency

BREAKING CHANGE: Output variable names have changed.
- `instance_id` is now `id`
- `instance_public_ip` is now `public_ip`
```

### Refactoring
```
refactor(module-name): reorganize resource blocks

Improves code readability without changing functionality.
```

## Integration with Terragrunt

Modules are designed to work with:
- Terragrunt catalog: `terragrunt catalog https://github.com/asajaroff/tofu-aws-modules`
- Terragrunt scaffold: `terragrunt scaffold https://github.com/asajaroff/tofu-aws-modules/modules/<path>//.`

## Additional Resources

- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [Project TODO](./docs/TODO.md)

## Questions?

Review the main [README.md](./README.md) for usage instructions and contribution guidelines.
