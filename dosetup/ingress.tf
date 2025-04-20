resource "kubernetes_ingress" "pumej" {
  metadata {
    name      = "pumej-ingress"
    namespace = kubernetes_namespace.pumej.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "cert-manager.io/cluster-issuer"           = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    tls {
      hosts      = [var.domain_name]
      secret_name = "pumej-tls"
    }

    rule {
      host = var.domain_name

      http {
        path {
          path = "/"

          backend {
            service_name = kubernetes_service.pumej_service.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}
