resource "helm_release" "argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "9.0.5"

  name      = "argocd"
  namespace = "argocd"

  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }

  values = [
    file("config/argocd.yaml")
  ]


  depends_on = [helm_release.cert-manager]
}
