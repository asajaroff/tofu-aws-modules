#!/bin/bash

# https://github.com/terraform-docs/terraform-docs
terraform-docs markdown table \
  --output-file README.md \
  --output-mode inject ./
