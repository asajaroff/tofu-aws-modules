# terraform/tofu-aws-modules
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
terragrunt catalog https://github.com/asajaroff/tofu-aws-modules
```

#### Scaffold
Use terragrunt's [scaffolding features](https://terragrunt.gruntwork.io/docs/features/scaffold/) to set up a particular module:
```bash
terragrunt scaffold https://github.com/asajaroff/tofu-aws-modules/modules/ec2//.
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

Please create your branch with the following options:

```bash
git checkout -b feature/new-module # for a new componenet
git checkout -b fix/title-or-error-msg # for fixing 
```