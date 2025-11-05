output "kubeconfig" {
  value       = digitalocean_kubernetes_cluster.this.kube_config.0.raw_config
  description = "Kubernetes config for the cluster"
  sensitive   = true
}

output "cluster_id" {
  value       = digitalocean_kubernetes_cluster.this.id
  description = "The ID of the Kubernetes cluster"
}

output "cluster_endpoint" {
  value       = digitalocean_kubernetes_cluster.this.endpoint
  description = "The endpoint of the Kubernetes cluster"
}

output "ingress_nginx_load_balancer_ip" {
  value       = try(data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip, "pending")
  description = "The external IP address of the nginx-ingress load balancer"
}

output "ingress_nginx_load_balancer_hostname" {
  value       = try(data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname, "pending")
  description = "The hostname of the nginx-ingress load balancer"
}

output "certmanager_iam_access_key_id" {
  value       = aws_iam_access_key.certmanager.id
  description = "The IAM access key ID for cert-manager Route53 integration"
  sensitive   = true
}

output "certmanager_iam_secret_access_key" {
  value       = aws_iam_access_key.certmanager.secret
  description = "The IAM secret access key for cert-manager Route53 integration"
  sensitive   = true
}
# output "letsencrypt_clusterissuer_name" {
#   value       = kubernetes_manifest.letsencrypt_clusterissuer.manifest.metadata.name
#   description = "The name of the Let's Encrypt ClusterIssuer"
# }
