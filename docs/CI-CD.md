# CI/CD Documentation

This repository uses automated workflows to maintain code quality and consistency.

## GitHub Actions

### Workflows

#### Validate Modules (`.github/workflows/validate.yml`)

Runs on all pull requests and pushes to main branch:

**1. Lint and Format Check**
- Validates OpenTofu formatting across all modules
- Fails if any files are not properly formatted
- Run locally: `tofu fmt -check -recursive`

**2. Module Validation**
- Validates syntax for all modules in parallel
- Ensures modules can be initialized
- Tests each module independently

**3. Documentation Check**
- Verifies README files are up-to-date
- Uses terraform-docs to validate documentation
- Ensures input/output tables are current

**4. Conventional Commits**
- Validates commit messages follow conventional commits
- Only runs on pull requests
- Checks all commits in the PR

### Viewing Workflow Results

1. Navigate to the **Actions** tab in GitHub
2. Select the workflow run
3. View individual job results
4. Check logs for any failures

## Pre-commit Hooks (Local Development)

Pre-commit hooks run automatically before each commit to catch issues early.

### Setup

Install pre-commit:

```bash
# Using pip
pip install pre-commit

# Using homebrew (macOS)
brew install pre-commit

# Using apt (Ubuntu/Debian)
sudo apt install pre-commit
```

Install the git hooks:

```bash
cd /path/to/tofu-modules
pre-commit install
pre-commit install --hook-type commit-msg
```

### What Gets Checked

Pre-commit will automatically:

1. **Format Terraform/Tofu files** - Runs `tofu fmt`
2. **Validate modules** - Runs `tofu validate`
3. **Generate documentation** - Updates README files
4. **Lint with tflint** - Catches common errors
5. **Remove trailing whitespace** - Cleans up files
6. **Fix end-of-file** - Ensures proper line endings
7. **Check YAML syntax** - Validates YAML files
8. **Prevent large files** - Blocks files >500KB
9. **Detect merge conflicts** - Catches conflict markers
10. **Detect private keys** - Prevents committing secrets
11. **Validate commit messages** - Enforces conventional commits

### Running Manually

Run on all files:
```bash
pre-commit run --all-files
```

Run specific hook:
```bash
pre-commit run terraform_fmt --all-files
pre-commit run terraform_validate --all-files
```

Skip pre-commit hooks (emergency only):
```bash
git commit --no-verify -m "message"
```

### Updating Hooks

Update to latest versions:
```bash
pre-commit autoupdate
```

## Commitlint

Validates commit messages follow [Conventional Commits](https://www.conventionalcommits.org/).

### Configuration

See `.commitlintrc.json` for rules.

### Allowed Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `build`: Build system changes
- `ci`: CI/CD changes
- `chore`: Maintenance tasks
- `revert`: Reverting changes

### Format Rules

- **Type**: Required, lowercase
- **Scope**: Optional, lowercase, in parentheses
- **Subject**: Required, no period at end
- **Header**: Max 100 characters
- **Breaking changes**: Use `!` after type/scope

### Valid Examples

```
feat(ec2): add instance tagging support
fix(s3): correct bucket policy validation
docs: update installation instructions
refactor(vpc)!: restructure network configuration
```

### Invalid Examples

```
Add new feature                    # Missing type
FEAT(ec2): new instance           # Type not lowercase
feat(EC2): new instance           # Scope not lowercase
feat: add feature.                # Period at end
feat(ec2): This is a really long commit message that exceeds the maximum allowed length  # Too long
```

## Continuous Integration Flow

### Pull Request Workflow

1. Developer creates branch and makes changes
2. Pre-commit hooks run locally (if installed)
3. Developer pushes commits
4. Developer opens pull request
5. GitHub Actions workflows run automatically:
   - Format check
   - Module validation
   - Documentation check
   - Commit message validation
6. All checks must pass before merge
7. Reviewers approve changes
8. PR is merged to main

### Main Branch Protection

Recommended branch protection rules:

- ✅ Require pull request before merging
- ✅ Require status checks to pass
  - validate / lint
  - validate / validate
  - validate / docs
  - validate / conventional-commits
- ✅ Require conversation resolution
- ✅ Do not allow bypassing requirements
- ❌ Allow force pushes (disabled)
- ❌ Allow deletions (disabled)

### Setting Up Branch Protection

1. Go to **Settings** → **Branches**
2. Click **Add rule**
3. Branch name pattern: `main`
4. Enable options above
5. Save changes

## Module Release Process

When releasing a new module version:

1. Update module code and documentation
2. Run `make docs` to regenerate README
3. Commit changes with conventional commit message
4. Create pull request
5. Wait for CI checks to pass
6. Merge PR
7. Create git tag: `<provider>/<module>/vX.Y.Z`
8. Push tag: `git push origin <tag-name>`

## Troubleshooting

### Pre-commit Fails

If pre-commit fails:

1. Read the error message carefully
2. Fix the issue (usually formatting or validation)
3. Stage the changes: `git add .`
4. Try committing again

### GitHub Actions Fails

If CI fails:

1. Click on the failed job in GitHub Actions
2. Review the logs
3. Fix the issue locally
4. Push the fix
5. CI will run automatically

### Skipping Checks (Emergency)

Only use in emergencies:

```bash
# Skip pre-commit
git commit --no-verify -m "message"

# Skip CI (add to commit message)
git commit -m "fix: emergency fix [skip ci]"
```

## Best Practices

1. **Install pre-commit hooks** - Catch issues before pushing
2. **Run validation locally** - Use `make validate` in modules
3. **Format before committing** - Use `tofu fmt -recursive`
4. **Write good commit messages** - Follow conventional commits
5. **Keep PRs focused** - One feature/fix per PR
6. **Update documentation** - Always regenerate README files
7. **Test module changes** - Validate before committing
8. **Review CI logs** - Learn from failures

## Additional Tools

### tflint

Install and use tflint for advanced linting:

```bash
# Install
brew install tflint

# Run
tflint --init
tflint
```

### infracost

Estimate costs before deploying:

```bash
# Install
brew install infracost

# Run
cd modules/<provider>/<module>
make cost
```

## Questions?

- GitHub Actions: https://docs.github.com/en/actions
- Pre-commit: https://pre-commit.com/
- Commitlint: https://commitlint.js.org/
- Conventional Commits: https://www.conventionalcommits.org/
