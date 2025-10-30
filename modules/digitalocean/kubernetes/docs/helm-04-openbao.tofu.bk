
# Install nginx-ingress controller using Helm
resource "helm_release" "openbao" {
  name       = "openbao"
  repository = "https://openbao.github.io/openbao-helm"
  chart      = "openbao"
  namespace  = "platform"
  version    = "0.19.1"

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

resource "aws_route53_record" "openbao" {
  zone_id = var.hosted_zone
  name    = "openbao.development.ar"
  type    = "A"
  ttl     = 300
  records = [ data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip ]
  depends_on = [
    helm_release.openbao
  ]
}
