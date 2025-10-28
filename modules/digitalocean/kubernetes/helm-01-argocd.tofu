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

values = [ <<EOV
global:
  domain: argocd.development.ar

certificate:
  enabled: true

server:
  extraArgs:
    - --insecure
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      cert-manager.io/cluster-issuer: "letsencrypt-prod"
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    tls: true
  ingressGrpc:
    enabled: false

EOV
]

  depends_on = [helm_release.cert-manager]
}
