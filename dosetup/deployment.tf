resource "kubernetes_deployment" "pumej_app" {
  metadata {
    name      = "pumej-app"
    namespace = kubernetes_namespace.pumej.metadata[0].name
    labels = {
      app = "pumej"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pumej"
      }
    }

    template {
      metadata {
        labels = {
          app = "pumej"
        }
      }

      spec {
        container {
          image = "pumejlab/amazon:v1.0" # Replace with your Docker image
          name  = "pumej-container"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pumej_service" {
  metadata {
    name      = "pumej-service"
    namespace = kubernetes_namespace.pumej.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.pumej_app.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

output "load_balancer_ip" {
  value = kubernetes_service.pumej_service.status[0].load_balancer[0].ingress[0].ip
}
