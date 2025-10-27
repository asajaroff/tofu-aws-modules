# DigitalOcean Kubernetes Cluster with nginx-ingress

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

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->