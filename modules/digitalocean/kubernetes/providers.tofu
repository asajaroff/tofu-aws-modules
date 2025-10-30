terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

provider "aws" {
  region = "us-east-1"
}

# Configure Helm provider using the cluster credentials
provider "helm" {
  kubernetes {
    host  = try(digitalocean_kubernetes_cluster.this.endpoint, "https://localhost")
    token = try(digitalocean_kubernetes_cluster.this.kube_config[0].token, "")
    cluster_ca_certificate = try(base64decode(
      digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
    ), "")
  }
}

# Configure Kubernetes provider using the cluster credentials
provider "kubernetes" {
  host  = try(digitalocean_kubernetes_cluster.this.endpoint, "https://localhost")
  token = try(digitalocean_kubernetes_cluster.this.kube_config[0].token, "")
  cluster_ca_certificate = try(base64decode(
      digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
    ), "")
}
