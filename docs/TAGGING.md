# Module Tagging Guide

This document describes the standard for tagging module releases in this repository.

## Tag Format

All module releases MUST follow this format:

```
<provider>/<module-name>/vX.Y.Z
```

### Examples

**AWS modules:**
```bash
aws/ec2/v1.2.0
aws/s3/v1.0.0
aws/cloudfront-s3-static-site/v1.0.1
```

**DigitalOcean modules:**
```bash
digitalocean/kubernetes/v1.0.0
digitalocean/vpc/v1.0.0
```

**Azure modules:**
```bash
azure/vm/v1.0.0
azure/storage/v1.0.0
```

**GCP modules:**
```bash
gcp/compute/v1.0.0
gcp/storage/v1.0.0
```

## Semantic Versioning

Follow [Semantic Versioning 2.0.0](https://semver.org/):

- **MAJOR version** (X): Breaking changes that require user action
  - Changing variable names
  - Removing outputs
  - Changing default behavior significantly
  - Requiring new required variables

- **MINOR version** (Y): New features, backwards-compatible
  - Adding new optional variables
  - Adding new outputs
  - Adding new resources (non-breaking)

- **PATCH version** (Z): Bug fixes, backwards-compatible
  - Fixing broken functionality
  - Updating documentation
  - Fixing security issues

### Pre-release Versions

For pre-release versions, append a hyphen and identifier:

```
aws/ec2/v1.0.0-alpha
aws/ec2/v1.0.0-beta
aws/ec2/v1.0.0-rc.1
```

## Creating a Release

### 1. Update Module Documentation

```bash
cd modules/<provider>/<module-name>
make docs
```

### 2. Update Module CHANGELOG

Add release notes to the module's CHANGELOG.md (create if doesn't exist):

```markdown
## [1.0.0] - 2025-11-14

### Added
- Initial release
- Support for basic configuration

### Changed
- N/A

### Fixed
- N/A
```

### 3. Commit Changes

```bash
git add .
git commit -m "feat(<module-name>): prepare v1.0.0 release"
```

### 4. Create and Push Tag

```bash
# Create annotated tag
git tag -a <provider>/<module-name>/v1.0.0 -m "Release <provider>/<module-name>/v1.0.0"

# Push tag to remote
git push origin <provider>/<module-name>/v1.0.0
```

### Example: Releasing EC2 v1.2.0

```bash
cd modules/aws/ec2
make docs
# Update CHANGELOG.md
git add .
git commit -m "feat(ec2): prepare v1.2.0 release"
git tag -a aws/ec2/v1.2.0 -m "Release aws/ec2/v1.2.0"
git push origin aws/ec2/v1.2.0
```

## Using Makefile Release Target

Each module has a Makefile with a `release` target. To use it:

```bash
cd modules/<provider>/<module-name>
make release VERSION=1.0.0
```

This will:
1. Create a tag: `<provider>/<module-name>/v1.0.0`
2. Push it to the remote repository

## Migrating Old Tags

### Current Tag Issues

Some older tags use incorrect formats:

**Hyphen format (deprecated):**
- `ec2-v1.0.0` → Should be `aws/ec2/v1.0.0`
- `eip-v1.0.0` → Should be `aws/eip/v1.0.0`

**Module-only format (deprecated):**
- `ec2/v1.1.0` → Should be `aws/ec2/v1.1.0`
- `do-kubernetes/v1.0.0` → Should be `digitalocean/kubernetes/v1.0.0`

### Migration Strategy

**DO NOT delete old tags** - they may be in use. Instead:

1. Create new tags with correct format
2. Document the mapping in release notes
3. Deprecate old tag format in documentation

Example:

```bash
# Old tag: ec2-v1.0.0
# New tag:
git tag -a aws/ec2/v1.0.0 -m "Release aws/ec2/v1.0.0 (replaces ec2-v1.0.0)"
git push origin aws/ec2/v1.0.0
```

## Tag Naming Rules

1. **Use forward slashes** (`/`) not hyphens (`-`) to separate components
2. **Include provider name** in the tag path
3. **Always prefix version** with `v` (e.g., `v1.0.0` not `1.0.0`)
4. **Use module directory name** exactly as it appears in `modules/<provider>/`
5. **Annotated tags only** - use `git tag -a` not `git tag`

## Querying Tags

### List all tags for a specific module

```bash
git tag -l "aws/ec2/*"
git tag -l "digitalocean/kubernetes/*"
```

### List latest tag for a module

```bash
git tag -l "aws/ec2/*" | sort -V | tail -1
```

### Show tag details

```bash
git show aws/ec2/v1.0.0
```

## Terragrunt Integration

With proper tagging, users can reference specific versions:

```hcl
terraform {
  source = "git::https://github.com/asajaroff/tofu-modules.git//modules/aws/ec2?ref=aws/ec2/v1.0.0"
}
```

## Best Practices

1. **Always create annotated tags** with meaningful messages
2. **Tag from the main branch** after merging
3. **Test thoroughly** before tagging a release
4. **Update documentation** before tagging
5. **Follow semantic versioning** strictly
6. **Use pre-release tags** for testing (alpha, beta, rc)
7. **Never force-push tags** - they should be immutable
8. **Create a GitHub/GitLab release** after pushing the tag

## Automation

Consider using GitHub Actions or GitLab CI to:
- Automatically validate tag format
- Generate release notes from commits
- Run tests before allowing tag creation
- Create GitHub releases automatically

## Questions?

Review the main [AGENTS.md](../AGENTS.md) for commit message conventions and other guidelines.
