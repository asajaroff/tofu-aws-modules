# Install kube-prometheus-stack
# https://github.com/prometheus-community/helm-charts/pkgs/container/charts%2Fkube-prometheus-stack
#

resource "helm_release" "kube-prometheus-stack" {
  name        = "kube-prometheus-stack"
  namespace   = "observability"
  repository  = "https://prometheus-community.github.io/helm-charts"
  version     = "79.0.0"
  chart       = "kube-prometheus-stack"

  create_namespace = true

  values = [ <<EOV

server:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-staging
    hosts:
      - host: openbao.development.ar
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: openbao-tls
        hosts:
          - openbao.development.ar

EOV
]


  depends_on = [
    helm_release.cert-manager,
    data.kubernetes_service.nginx_ingress
  ]
}

resource "aws_route53_record" "prometheus" {
  zone_id = var.hosted_zone
  name    = "prometheus.development.ar"
  type    = "A"
  ttl     = 300
  records = [ data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip ]
  depends_on = [
    helm_release.openbao
  ]
}
