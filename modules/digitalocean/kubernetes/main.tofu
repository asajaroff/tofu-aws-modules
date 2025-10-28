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
