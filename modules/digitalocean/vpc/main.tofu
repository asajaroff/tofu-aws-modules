# main.tf
resource "digitalocean_vpc" "this" {
  name     = var.name
  region   = var.region
  ip_range = "10.10.10.0/24"
}
