# Developer note:
#
# Run `make` or `make help` to display a list of targets and help texts.
#
# If you add a new command, add a help text by adding a comment on the same
# line as the target name. You should use the following structure:
# `<target name>:  ## <help text>`
.PHONY: help
.DEFAULT_GOAL := help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# Variables
TF_CMD := $(shell which terraform)
TOFU_CMD := $(shell which tofu)

.PHONY: format
# Targets
format: ## Formats code with `fmt -recursive`
	@${TF_CMD} fmt -recursive

.PHONY: docs
docs: ## Generate documentation for README.md
	@terraform-docs markdown table --output-file README.md .
	@git add README.md
	@git commit -m "docs: Autogenerated README.md updates"


.PHONY: generate-vars
generate-vars: ## Generates an example default.tfvars file
	@terraform-docs tfvars hcl . | tee default.tfvars

.PHONY: plan
plan: ## Generates a plan with the default.tfvars variable
	@tofu validate
	@tofu plan --var-file default.tfvars -out tfplan

.PHONY: apply
apply: ## Applies the plan generated by the plan target
	@tofu apply "tfplan"

.PHONY: test
test: ## Generates a plan with the default.tfvars variable
	@tofu init -reconfigure
	@tofu validate
	@tofu plan --var-file default.tfvars -out tfplan
	@tofu apply tfplan
	@tofu destroy --var-file default.tfvars -auto-approve

.PHONY: cost
cost: ## Calculates costs of the current module
	@infracost breakdown --path .

keys: ## Sets up the local discardable key
	tofu output -raw private_key > ~/.ssh/discard
	chmod 400 ~/.ssh/discard

tflock: ## Generates the lockfile
	tofu providers lock \
  -platform=windows_amd64 \
  -platform=darwin_amd64 \
  -platform=darwin_arm64 \
  -platform=linux_amd64 \
  -platform=linux_arm64
