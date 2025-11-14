# Roadmap

This document tracks current, pending, and future work for the tofu-aws-modules repository.

## Current Focus

### High Priority
- [ ] Complete incomplete AWS modules (EIP, Route53, ACM)
- [ ] Add module examples directory with real-world use cases
- [ ] Implement comprehensive testing with Terratest
- [ ] Create module dependency documentation

### Medium Priority
- [ ] Add architecture diagrams for complex modules
- [ ] Implement cost estimation examples
- [ ] Create composition examples (multi-module usage)
- [ ] Add troubleshooting guides for each module

## Module Status

### AWS Modules

| Module | Status | Version | Notes |
|--------|--------|---------|-------|
| EC2 | ✅ Production | v1.1.0 | Comprehensive, well-documented |
| CloudFront-S3-Static-Site | ✅ Production | v1.0.0 | Complete static site solution |
| EIP | ⚠️ Incomplete | v1.0.0 | Needs outputs and documentation |
| S3 | 🔄 In Progress | - | Basic implementation |
| Route53 | ⚠️ Incomplete | - | Missing outputs documentation |
| ACM | ⚠️ Incomplete | - | Minimal implementation |
| CDN | 🔄 In Progress | - | CloudFront distribution |

### DigitalOcean Modules

| Module | Status | Version | Notes |
|--------|--------|---------|-------|
| Kubernetes | ✅ Production | v1.0.0 | Complete with Helm examples |
| VPC | ✅ Production | v1.0.0 | Network configuration |

### Azure Modules

| Module | Status | Version | Notes |
|--------|--------|---------|-------|
| - | 📋 Planned | - | Placeholder directory ready |

### GCP Modules

| Module | Status | Version | Notes |
|--------|--------|---------|-------|
| - | 📋 Planned | - | Placeholder directory ready |

**Legend:**
- ✅ Production: Fully functional and documented
- 🔄 In Progress: Partially implemented
- ⚠️ Incomplete: Needs work before production use
- 📋 Planned: Not yet started

## Planned AWS Modules

### Compute
- [ ] **Lambda** - Serverless functions
- [ ] **ECS** - Container orchestration
- [ ] **EKS** - Managed Kubernetes
- [ ] **Auto Scaling Groups** - Scalable compute

### Networking
- [ ] **VPC** - Virtual Private Cloud
- [ ] **Application Load Balancer** - Layer 7 load balancing
- [ ] **Network Load Balancer** - Layer 4 load balancing
- [ ] **API Gateway** - API management
- [ ] **VPC Peering** - Network connectivity
- [ ] **VPN Gateway** - Site-to-site VPN

### Database
- [ ] **RDS** - Managed relational databases (PostgreSQL, MySQL, etc.)
- [ ] **Aurora** - High-performance database
- [ ] **DynamoDB** - NoSQL database
- [ ] **ElastiCache** - In-memory caching (Redis, Memcached)
- [ ] **DocumentDB** - MongoDB-compatible database

### Storage
- [ ] **EBS Volumes** - Block storage
- [ ] **EFS** - Elastic File System
- [ ] **S3 Glacier** - Archive storage
- [ ] **Storage Gateway** - Hybrid storage

### Security
- [ ] **IAM Roles** - Identity management
- [ ] **IAM Policies** - Permission management
- [ ] **Security Groups** - Network firewalls
- [ ] **KMS** - Key Management Service
- [ ] **Secrets Manager** - Secrets storage
- [ ] **WAF** - Web Application Firewall

### Monitoring & Logging
- [ ] **CloudWatch** - Monitoring and alerting
- [ ] **CloudTrail** - Audit logging
- [ ] **X-Ray** - Distributed tracing

### CI/CD
- [ ] **CodePipeline** - Continuous delivery
- [ ] **CodeBuild** - Build service
- [ ] **CodeDeploy** - Deployment automation

## Planned DigitalOcean Modules

- [ ] **Droplets** - Virtual machines
- [ ] **Load Balancer** - Traffic distribution
- [ ] **Database** - Managed databases
- [ ] **Spaces** - Object storage
- [ ] **Firewall** - Cloud firewall
- [ ] **Container Registry** - Docker registry

## Planned Azure Modules

- [ ] **Virtual Machines** - Compute instances
- [ ] **Storage Accounts** - Blob, file, queue storage
- [ ] **Virtual Networks** - Network configuration
- [ ] **AKS** - Azure Kubernetes Service
- [ ] **App Service** - Web app hosting
- [ ] **Key Vault** - Secrets management

## Planned GCP Modules

- [ ] **Compute Engine** - Virtual machines
- [ ] **GKE** - Google Kubernetes Engine
- [ ] **Cloud Storage** - Object storage
- [ ] **Cloud SQL** - Managed databases
- [ ] **VPC Networks** - Network configuration

## Infrastructure Improvements

### Testing
- [ ] Implement Terratest for integration testing
- [ ] Add example configurations for each module
- [ ] Create test fixtures and mock data
- [ ] Set up automated testing in CI/CD
- [ ] Add cost estimation tests

### Documentation
- [ ] Add architecture diagrams (draw.io or mermaid)
- [ ] Create video tutorials for complex modules
- [ ] Write migration guides between versions
- [ ] Add performance benchmarking documentation
- [ ] Create security best practices guide

### Tooling
- [ ] Implement automated changelog generation
- [ ] Add semantic release automation
- [ ] Create module scaffolding CLI tool
- [ ] Implement automated tag creation
- [ ] Add cost estimation automation

### Quality
- [ ] Implement security scanning (tfsec, checkov)
- [ ] Add compliance checking (CIS benchmarks)
- [ ] Create performance testing framework
- [ ] Implement dependency scanning

## Repository Improvements

### Completed ✅
- [x] Standardize git tag format to `<provider>/<module>/vX.Y.Z`
- [x] Add comprehensive AGENTS.md guidelines
- [x] Create TAGGING.md documentation
- [x] Fix file extension inconsistencies (.tofu → .tf)
- [x] Standardize Makefiles (TOFU_CMD only)
- [x] Add GitHub Actions CI/CD workflows
- [x] Add pre-commit hooks configuration
- [x] Enhance .gitignore with OS and IDE patterns
- [x] Add Azure and GCP placeholder READMEs

### In Progress 🔄
- [ ] Create MODULES.md catalog
- [ ] Fix incomplete modules (EIP, Route53, ACM)

### Planned 📋
- [ ] Migrate old git tags to new format
- [ ] Publish modules to Terraform Registry
- [ ] Create web-based module browser
- [ ] Add GitHub issue templates
- [ ] Add pull request templates
- [ ] Create SECURITY.md policy
- [ ] Add CODE_OF_CONDUCT.md
- [ ] Create CONTRIBUTING.md guide

## Community & Adoption

- [ ] Create example infrastructure repository
- [ ] Write blog posts about module usage
- [ ] Create tutorial series
- [ ] Add module usage analytics
- [ ] Create module comparison guides
- [ ] Build community showcase

## Long-term Goals

### Q1 2025
- Complete all incomplete AWS modules
- Implement comprehensive testing
- Add 5 new AWS modules
- Publish to Terraform Registry

### Q2 2025
- Add 10 more AWS modules
- Start Azure module development
- Implement automated releases
- Create web documentation site

### Q3 2025
- Add 5 Azure modules
- Start GCP module development
- Implement cost optimization tools
- Create video tutorial series

### Q4 2025
- Add 5 GCP modules
- Complete 25 total production modules
- Launch community showcase
- Achieve 1000+ GitHub stars

## Contributing

Want to contribute? Check out:
- [AGENTS.md](../AGENTS.md) - Contribution guidelines
- [TAGGING.md](./TAGGING.md) - Version tagging standards
- [CI-CD.md](./CI-CD.md) - Development workflow

Pick an item from the roadmap and open an issue or pull request!

## Questions?

Open an issue on GitHub to discuss roadmap items or suggest new priorities.
