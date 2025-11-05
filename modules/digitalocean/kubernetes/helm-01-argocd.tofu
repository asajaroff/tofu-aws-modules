resource "helm_release" "argocd" {
  chart     = "oci://ghcr.io/argoproj/argo-helm/argo-cd"
  version   = "9.0.5"
  name      = "argocd"
  namespace = "argocd"

  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }

  values = [file("${path.module}/config/argocd.yaml")]

  depends_on = [
    digitalocean_kubernetes_cluster.this,
    helm_release.cert-manager,
    helm_release.nginx_ingress
  ]
}
