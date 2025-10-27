resource "helm_release" "gitea" {
  name       = "gitea"
  repository = "https://dl.gitea.com/charts/"
  chart      = "gitea"
  namespace  = "services"
  version    = "v12.4.0"

  create_namespace = true

  values = [ <<EOV
valkey-cluster:
  enabled: false
valkey:
  enabled: true
postgresql:
  enabled: true
postgresql-ha:
  enabled: false

ingress:
  enabled: true
  className: "nginx"
  pathType: Prefix
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: git.development.ar
      paths:
        - path: /
  tls:
    - secretName: gitea-tls
      hosts:
        - git.development.ar


persistence:
  enabled: true

gitea:
  config:
    server:
      PROTOCOL: https
      DOMAIN: git.development.ar
      ROOT_URL: https://git.development.ar/
    database:
      DB_TYPE: postgres
    indexer:
      ISSUE_INDEXER_TYPE: bleve
      REPO_INDEXER_ENABLED: true
EOV

  ]

  set {
    name  = "gitea.admin.username"
    value = "Galera"
  }

  set {
    name  = "gitea.admin.password"
    value = "brutaPasswordPegaste123"
  }

  set {
    name  = "gitea.admin.email"
    value = "galeira@pm.me"
  }
  depends_on = [
    digitalocean_kubernetes_cluster.this,
    kubernetes_manifest.letsencrypt_clusterissuer
  ]
}
