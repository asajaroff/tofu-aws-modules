resource "helm_release" "fluent-operator" {
  name       = "fluent-operator"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-operator"
  namespace  = "platform"
  version    = "3.5.0"

  create_namespace = true

  values = [
    file("config/fluent-operator.yaml")
  ]

  set {
    name  = "containerRuntime"
    value = "containerd"
  }


  depends_on = [
    digitalocean_kubernetes_cluster.this,
  ]
}
