resource "aws_route53_record" "argocd" {
  zone_id = var.hosted_zone
  name    = "argocd.development.ar"
  type    = "A"
  ttl     = 300
  records = [ data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip ]
  depends_on = [
    helm_release.argocd,
    helm_release.cert-manager
  ]
}
