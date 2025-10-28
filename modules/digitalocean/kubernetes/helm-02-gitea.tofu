
# Install nginx-ingress controller using Helm
resource "helm_release" "gitea" {
  name       = "gitea"
  repository = "https://dl.gitea.com/charts/"
  chart      = "gitea"
  namespace  = "gitea"
  version    = "v12.4.0"

  create_namespace = true

  values = [ <<EOV
gitea:
  config:
    APP_NAME: "Gitea - sources for development.ar"
    repository:
      ROOT: "~/gitea-repositories"
    repository.pull-request:
      WORK_IN_PROGRESS_PREFIXES: "WIP:,[WIP]:"

  admin:
    username: "galera"
    password: "AReallyAwesomeGiteaPassword"
    email: "galera@pm.me"

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-staging
  hosts:
    - host: git.development.ar
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: gitea-tls
      hosts:
        - git.development.ar
EOV
  ]


  depends_on = [
    digitalocean_kubernetes_cluster.this,
    helm_release.cert-manager
  ]
}

# # Data source to get the Load Balancer service details
# data "kubernetes_service" "nginx_ingress" {
#   metadata {
#     name      = "ingress-nginx-controller"
#     namespace = "ingress-nginx"
#   }

#   depends_on = [helm_release.gitea]
# }

resource "aws_route53_record" "gitea" {
  zone_id = var.hosted_zone
  name    = "git.development.ar"
  type    = "A"
  ttl     = 300
  records = [ data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip ]
  depends_on = [
    helm_release.gitea
  ]
}
