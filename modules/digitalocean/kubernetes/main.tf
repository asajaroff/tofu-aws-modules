data "digitalocean_kubernetes_versions" "this" {
  version_prefix = "1.33."
}

resource "digitalocean_kubernetes_cluster" "this" {
  name    = var.name
  region  = var.region
  version = data.digitalocean_kubernetes_versions.this.latest_version

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  # Query size names from the DO api
  # curl -X GET \
  #  -H "Content-Type: application/json" \
  #  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  #  "https://api.digitalocean.com/v2/sizes" | jq

  node_pool {
    name       = "s-1vcpu-2gb"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5

  }
}


resource "digitalocean_kubernetes_node_pool" "platform" {
  cluster_id = digitalocean_kubernetes_cluster.this.id
  name       = "platform-pool"
  size       = "s-1vcpu-2gb"
  auto_scale = true
  min_nodes  = 0
  max_nodes  = 2

  tags = ["some-tag"]

  #  labels = {
  #    service  = "backend"
  #    role     = "platform"
  #    priority = "high"
  #  }
  #
  #  taint {
  #    key    = "workloadKind"
  #    value  = "database"
  #    effect = "NoSchedule"
  #  }
}

resource "digitalocean_kubernetes_node_pool" "servers" {
  cluster_id = digitalocean_kubernetes_cluster.this.id
  name       = "servers-pool"
  size       = "s-1vcpu-2gb"
  auto_scale = true
  min_nodes  = 0
  max_nodes  = 2
  taint {
    key    = "role"
    value  = "server"
    effect = "NoSchedule"
  }
}
