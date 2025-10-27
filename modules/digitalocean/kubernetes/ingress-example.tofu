# Example Ingress resource configuration
# Uncomment and modify this to expose your applications

# Example deployment and service
resource "kubernetes_deployment" "example_app" {
  count = var.create_example_app ? 1 : 0

  metadata {
    name      = "example-app"
    namespace = "default"
    labels = {
      app = "example-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "example-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "example-app"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }

  depends_on = [digitalocean_kubernetes_cluster.this]
}

resource "kubernetes_service" "example_app" {
  count = var.create_example_app ? 1 : 0

  metadata {
    name      = "example-app"
    namespace = "default"
  }

  spec {
    selector = {
      app = "example-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.example_app]
}

# Example Ingress resource to expose the app
resource "kubernetes_ingress_v1" "example_app" {
  count = var.create_example_app ? 1 : 0

  metadata {
    name      = "example-app-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      # Uncomment to enable SSL redirect
      # "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
      # Uncomment to enable cert-manager for automatic SSL
      # "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }

  spec {
    rule {
      host = var.example_app_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.example_app[0].metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    # Uncomment to enable TLS
    # tls {
    #   hosts       = [var.example_app_hostname]
    #   secret_name = "example-app-tls"
    # }
  }

  depends_on = [helm_release.nginx_ingress]
}
