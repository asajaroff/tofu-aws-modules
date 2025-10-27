# resource "helm_release" "thanos" {
#   name       = "thanos"
#   repository = "oci://registry-1.docker.io/bitnamicharts"
#   chart      = "thanos"
#   namespace  = "platform"
#   version    = "v12.4.0"

#   create_namespace = true

#   values = [ <<EOV
# # Values
# EOV
#   ]

#   set {
#     name  = "gitea.admin.username"
#     value = "Galera"
#   }

#   set {
#     name  = "gitea.admin.password"
#     value = "brutaPasswordPegaste123"
#   }

#   set {
#     name  = "gitea.admin.email"
#     value = "galeira@pm.me"
#   }

#   depends_on = [
#     digitalocean_kubernetes_cluster.this,
#     helm_release.cert-manager,
#     helm_release.fluent-operator
#   ]
# }
