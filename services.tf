resource "kubernetes_service" "main" {
  depends_on = [kubernetes_deployment.main]
  count      = var.service_enabled ? 1 : 0
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      env = var.env
      app = var.app_name
    }
  }
  spec {
    selector = {
      app = var.app_name
      env = var.env
    }
    port {
      port        = var.service_port
      protocol    = "TCP"
      target_port = var.container_port
    }

    type = var.service_type
  }
}
