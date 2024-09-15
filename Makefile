.PHONY=echo



terraform-tools-install:
	@brew install terraform-docs


echo:
	@echo hello from make

terraform-generate-docs:
	@echo "terraform-docs markdown table --output-file README.md ."

terraform-format:
	terraform fmt -recursive
