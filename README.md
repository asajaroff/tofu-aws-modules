# terraform/tofu-modules
Collection of `opentofu`/`terraform` modules.

This modules have been designed for standalone usage or with a wrapper tool such as `terragrunt`. A live infrastructure that uses this modules can be found [here](https://github.com/asajaroff/cloud-infrastructure-org).

## Usage

Modules are located in the [modules](./modules/) folder. Descriptions for inputs/outputs are provided in the `README` files.

In some cases, such as the [EC2 module](./modules/ec2/).

Import the required module and specify the required inputs.

### Browse the catalog


#### Catalog
Use terragrunt's [catalog explorer](https://terragrunt.gruntwork.io/docs/features/catalog/) to go through the modules:

```bash
terragrunt catalog https://github.com/asajaroff/tofu-modules
```

#### Scaffold
Use terragrunt's [scaffolding features](https://terragrunt.gruntwork.io/docs/features/scaffold/) to set up a particular module:
```bash
terragrunt scaffold https://github.com/asajaroff/tofu-modules/modules/ec2//.
```

## Developing

### Create a new module
To create a new module, run:
```bash
mkdir modules/example-component
cp module.Makefile modules/example-component/Makefile
cd modules/example-component
touch {main,variables,providers,outputs}.tf
```

### Automations
A [Makefile](./module.Makefile) is provided for automated commmon tasks such as linting, building, updating, destroying, testing, docs generation and module-specific tasks, such as configuring or deploying a component or uploading a file somewhere.

## Contributing

If you're interested to help, start reviewing the [TODO.md](./docs/TODO.md) documentation.

This repository follows the [conventional commit message](https://www.conventionalcommits.org/en/v1.0.0-beta.2/#specification) specification.

### Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

1. Commits MUST be prefixed with a type, which consists of a noun, `feat`, `fix`, etc., followed
  by an OPTIONAL scope, and a REQUIRED terminal colon and space.
1. The type `feat` MUST be used when a commit adds a new feature to your application or library.
1. The type `fix` MUST be used when a commit represents a bug fix for your application.
1. A scope MAY be provided after a type. A scope MUST consist of a noun describing a
  section of the codebase surrounded by parenthesis, e.g., `fix(parser):`
1. A description MUST immediately follow the space after the type/scope prefix.
The description is a short summary of the code changes, e.g., _fix: array parsing issue when multiple spaces were contained in string._
1. A longer commit body MAY be provided after the short description, providing additional contextual information about the code changes. The body MUST begin one blank line after the description.
1. A footer of one or more lines MAY be provided one blank line after the body. The footer MUST contain meta-information
about the commit, e.g., related pull-requests, reviewers, breaking changes, with one piece of meta-information
per-line.
1. Breaking changes MUST be indicated at the very beginning of the body section, or at the beginning of a line in the footer section. A breaking change MUST consist of the uppercase text BREAKING CHANGE, followed by a colon and a space.
1. A description MUST be provided after the `BREAKING CHANGE: `, describing what has changed about the API, e.g., _BREAKING CHANGE: environment variables now take precedence over config files._
1. Types other than `feat` and `fix` MAY be used in your commit messages.
1. The units of information that make up conventional commits MUST NOT be treated as case sensitive by implementors, with the exception of BREAKING CHANGE which MUST be uppercase.
1. A `!` MAY be appended prior to the `:` in the type/scope prefix, to further draw attention to breaking changes. `BREAKING CHANGE: description` MUST also be included in the body
or footer, along with the `!` in the prefix.
