resource "kubernetes_ingress_v1" "main" {
  depends_on             = [kubernetes_deployment.main]
  count                  = var.ingress_enabled ? 1 : 0
  wait_for_load_balancer = var.wait_for_load_balancer
  metadata {
    name        = var.app_name
    namespace   = var.namespace
    annotations = var.ingress_annotations
  }

  spec {
    dynamic "rule" {
      for_each = var.hosts
      content {
        host = rule.value
        http {
          path {
            backend {
              service {
                name = var.app_name
                port {
                  number = var.service_port
                }
              }
            }
            path      = "/"
            path_type = "Prefix"
          }
        }
      }
    }

    tls {
      hosts       = var.tls_hosts
      secret_name = format("%s-tls", var.app_name)
    }
  }
}
