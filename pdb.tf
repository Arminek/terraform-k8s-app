resource "kubernetes_pod_disruption_budget" "main" {
  count = var.pdb_enabled ? 1 : 0
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    max_unavailable = var.pdb_max_unavailable

    selector {
      match_labels = {
        app = var.app_name
        env = var.env
      }
    }
  }
}
