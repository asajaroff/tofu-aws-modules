# Install kube-prometheus-stack
# https://github.com/prometheus-community/helm-charts/pkgs/container/charts%2Fkube-prometheus-stack
#

resource "helm_release" "kube-prometheus-stack" {
  name      = "monitoring"
  namespace = "observability"
  chart     = "oci://ghcr.io/prometheus-community/charts/kube-prometheus-stack"
  version   = "79.0.0"

  create_namespace = true

  values = [file("${path.module}/config/kube-prometheus-stack.yaml")]

  depends_on = [
    digitalocean_kubernetes_cluster.this,
    helm_release.cert-manager,
    helm_release.nginx_ingress,
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
    helm_release.kube-prometheus-stack
  ]
}

resource "aws_route53_record" "grafana" {
  zone_id = var.hosted_zone
  name    = "grafana.development.ar"
  type    = "A"
  ttl     = 300
  records = [ data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip ]
  depends_on = [
    helm_release.kube-prometheus-stack
  ]
}
