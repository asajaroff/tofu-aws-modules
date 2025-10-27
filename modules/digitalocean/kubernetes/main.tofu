resource "digitalocean_kubernetes_cluster" "this" {
  name   = var.name
  region = var.region
  version = "1.33.1-do.5"

# Query size names from the DO api
# curl -X GET \
#  -H "Content-Type: application/json" \
#  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
#  "https://api.digitalocean.com/v2/sizes" | jq

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5

    # taint {
    #   key    = "role"
    #   value  = "server"
    #   effect = "NoSchedule"
    # }
  }
}

# Install nginx-ingress controller using Helm
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.11.3"

  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.podAnnotations.prometheus\\.io/scrape"
    value = "true"
  }

  set {
    name  = "controller.podAnnotations.prometheus\\.io/port"
    value = "10254"
  }

  depends_on = [digitalocean_kubernetes_cluster.this]
}

# Data source to get the Load Balancer service details
data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [helm_release.nginx_ingress]
}
