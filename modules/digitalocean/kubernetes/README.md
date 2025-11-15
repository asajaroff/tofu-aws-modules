# DigitalOcean Kubernetes Cluster

This module creates a DigitalOcean Kubernetes cluster with nginx-ingress controller pre-installed via Helm.

## Design

This module provisions:
- A DigitalOcean Kubernetes cluster with autoscaling node pool
- nginx-ingress controller deployed via Helm chart
- Load Balancer service for external traffic routing
- Optional example application with ingress resource

The nginx-ingress controller is automatically configured to use a DigitalOcean Load Balancer, which provides a stable external IP address for routing HTTP/HTTPS traffic to your services.

## Usage

### Basic Usage

```hcl
module "k8s_cluster" {
  source = "./modules/digitalocean/kubernetes"

  name     = "my-k8s-cluster"
  region   = "ams3"
  do_token = var.do_token
}
```

### With Example Application

```hcl
module "k8s_cluster" {
  source = "./modules/digitalocean/kubernetes"

  name                 = "my-k8s-cluster"
  region               = "ams3"
  do_token             = var.do_token
  create_example_app   = true
  example_app_hostname = "app.example.com"
}
```

### Exposing Your Own Application

After deploying the cluster, you can expose your applications using Ingress resources:

```hcl
resource "kubernetes_ingress_v1" "my_app" {
  metadata {
    name      = "my-app-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "myapp.example.com"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "my-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
```

### DNS Configuration

After applying the terraform configuration, get the Load Balancer IP:

```bash
terraform output ingress_nginx_load_balancer_ip
```

Then create an A record in your DNS provider pointing your domain to this IP address:

```
myapp.example.com. IN A <LOAD_BALANCER_IP>
```

### SSL/TLS with cert-manager (Optional)

To enable automatic SSL certificates, install cert-manager:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.yaml
```

Then create a ClusterIssuer and add annotations to your Ingress:

```hcl
annotations = {
  "kubernetes.io/ingress.class"              = "nginx"
  "cert-manager.io/cluster-issuer"           = "letsencrypt-prod"
  "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.18.0 |
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.68.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.certmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.certmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.certmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_route53_record.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [digitalocean_kubernetes_cluster.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_cluster) | resource |
| [digitalocean_kubernetes_node_pool.platform](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_node_pool) | resource |
| [digitalocean_kubernetes_node_pool.servers](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_node_pool) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.letsencrypt_clusterissuer_prod](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.letsencrypt_clusterissuer_staging](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.certmanager_aws_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_iam_policy_document.certmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [digitalocean_kubernetes_versions.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_versions) | data source |
| [kubernetes_service.nginx_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for Route53 | `string` | `"us-east-1"` | no |
| <a name="input_create_example_app"></a> [create\_example\_app](#input\_create\_example\_app) | Whether to create an example app with ingress | `bool` | `false` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | Token | `string` | n/a | yes |
| <a name="input_example_app_hostname"></a> [example\_app\_hostname](#input\_example\_app\_hostname) | Hostname for the example app ingress | `string` | `"example.yourdomain.com"` | no |
| <a name="input_gitea_admin_email"></a> [gitea\_admin\_email](#input\_gitea\_admin\_email) | Gitea admin email address | `string` | n/a | yes |
| <a name="input_gitea_admin_password"></a> [gitea\_admin\_password](#input\_gitea\_admin\_password) | Gitea admin password | `string` | n/a | yes |
| <a name="input_gitea_admin_username"></a> [gitea\_admin\_username](#input\_gitea\_admin\_username) | Gitea admin username | `string` | `"galera"` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | The AWS hosted zone ID in Route53 where the domain controlled by cert-manager lives. | `string` | `""` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email address for Let's Encrypt ACME registration | `string` | n/a | yes |
| <a name="input_letsencrypt_server_prod"></a> [letsencrypt\_server\_prod](#input\_letsencrypt\_server\_prod) | Let's Encrypt ACME server URL (use staging for testing: https://acme-staging-v02.api.letsencrypt.org/directory) | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_letsencrypt_server_staging"></a> [letsencrypt\_server\_staging](#input\_letsencrypt\_server\_staging) | Let's Encrypt ACME server URL -staging- | `string` | `"https://acme-staging-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Kubernetes cluster | `string` | `"development-ar-do-ams3"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the VPC will be deployed | `string` | `"ams3"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certmanager_iam_access_key_id"></a> [certmanager\_iam\_access\_key\_id](#output\_certmanager\_iam\_access\_key\_id) | The IAM access key ID for cert-manager Route53 integration |
| <a name="output_certmanager_iam_secret_access_key"></a> [certmanager\_iam\_secret\_access\_key](#output\_certmanager\_iam\_secret\_access\_key) | The IAM secret access key for cert-manager Route53 integration |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint of the Kubernetes cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the Kubernetes cluster |
| <a name="output_ingress_nginx_load_balancer_hostname"></a> [ingress\_nginx\_load\_balancer\_hostname](#output\_ingress\_nginx\_load\_balancer\_hostname) | The hostname of the nginx-ingress load balancer |
| <a name="output_ingress_nginx_load_balancer_ip"></a> [ingress\_nginx\_load\_balancer\_ip](#output\_ingress\_nginx\_load\_balancer\_ip) | The external IP address of the nginx-ingress load balancer |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Kubernetes config for the cluster |
<!-- END_TF_DOCS -->
