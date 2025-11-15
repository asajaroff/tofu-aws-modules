## Repository structure

- All values file must be pointing to `config/<values-file>.yaml`
- This is an opentofu <tofu> repository
- It uses a Makefile for local deployment and development
- variables are declared in variables.tf

```
$ tree ./
./
├── argocd
│   ├── project.argocd.yaml
│   ├── projects.yaml
│   ├── README.md
│   ├── repositories.yaml
│   ├── repository.yaml
│   └── teams.yaml
├── CHAGENLOG
├── CLAUDE.md
├── config
│   ├── argocd.yaml
│   ├── fluent-operator.yaml
│   ├── gitea.yaml
│   └── kube-prometheus-stack.yaml
├── default.tfvars
├── dns.tofu
├── docs
│   ├── 00-Setup.md
│   ├── helm-02-gitea.tofu
│   ├── helm-02-prometheus.tofu
│   ├── helm-03-minio.tofu
│   ├── helm-04-openbao.tofu.bk
│   └── sample-staging-cert.yaml
├── helm-00-certmanager.tofu
├── helm-00-nginx.tofu
├── helm-01-argocd.tofu
├── kubeconfig
├── main.tofu
├── Makefile
├── outputs.tofu
├── providers.tofu
├── README.md
├── terraform.tfstate
├── terraform.tfstate.backup
├── tfplan
├── tfplan-all
└── variables.tofu
```

## Makefile
- Steps are documented
-

## Helm deployment information
- Helm Charts should be ideally pointing to an OCI registry
- All ingresses should be exposed with the "nginx" ingress class
- All exposed ingresses should have the cert-manager anotation for the creation of the cert
