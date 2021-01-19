resource "kubernetes_deployment" "lteapplication" {
  metadata {
    name = "lteapplication"
    labels = {
      App = "LTEApplication"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "LTEApplication"
      }
    }
    template {
      metadata {
        labels = {
          App = "LTEApplication"
        }
      }
      spec {
        container {
          image = "${var.lte_app_image}"
          name  = "lte-app-container"

          port {
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "lteapplication" {
  metadata {
    name = "lteapplication"
  }
  spec {
    selector = {
      App = kubernetes_deployment.lteapplication.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
  depends_on = [
    module.eks,
  ]
}
