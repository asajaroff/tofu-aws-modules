# terraform/tofu-aws-s3-website
Creates a bucket to host a static website in a secure fashion.

A content distribution is optional, but recommended.

## Development usage

```hcl
# Include the root terragrunt.hcl config
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "/Users/alejandrosajaroff/Code/github.com/asajaroff/tf-aws-s3-website/modules/s3"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}


inputs = {
  name = "example-name-${local.env}"
  domain_name = "example.com."
  redirects_name = ["www.example.com", "some.example.com", "other.example.com"]
  enable_cdn = true
}
```

## Trailling URLs
ToDo