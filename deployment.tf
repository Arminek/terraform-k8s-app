resource "kubernetes_deployment" "main" {
  wait_for_rollout = var.wait_for_deployment_rollout
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      env = var.env
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        env = var.env
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          env = var.env
          app = var.app_name
        }
      }

      spec {
        dynamic "volume" {
          for_each = var.volume_enabled == true ? [1] : []
          content {
            name = var.volume_name
            persistent_volume_claim {
              claim_name = var.persistent_volume_claim_name
            }
          }
        }
        node_selector = var.node_selector
        runtime_class_name = var.runtime_class_name
        container {
          dynamic "volume_mount" {
            for_each = var.volume_enabled == true ? [1] : []
            content {
              mount_path = var.volume_mount_path
              name       = var.volume_name
            }
          }
          image_pull_policy = var.image_pull_policy
          image             = lower(var.app_docker_image)
          name              = var.app_name
          dynamic "env" {
            for_each = var.envs_from_value
            content {
              name  = env.value.name
              value = env.value.value
            }
          }
          dynamic "env" {
            for_each = var.envs_from_secrets
            content {
              name = env.value.name
              value_from {
                secret_key_ref {
                  name = env.value.secret_name
                  key  = env.value.secret_key
                }
              }
            }
          }
          dynamic "env" {
            for_each = var.envs_from_configmaps
            content {
              name = env.value.name
              value_from {
                config_map_key_ref {
                  name = env.value.config_name
                  key  = env.value.config_key
                }
              }
            }
          }
          port {
            container_port = var.container_port
          }
          resources {
            limits   = var.resources_limits
            requests = var.resources_requests
          }
          dynamic "readiness_probe" {
            for_each = var.readiness_probe_enabled == true ? [1] : []
            content {
              http_get {
                path = var.readiness_probe_path
                port = var.container_port
              }
              initial_delay_seconds = var.readiness_probe_initial_delay_seconds
              period_seconds        = var.readiness_probe_period_seconds
              timeout_seconds       = var.readiness_probe_timeout_seconds
              success_threshold     = var.readiness_probe_success_threshold
              failure_threshold     = var.readiness_probe_failure_threshold
            }
          }
          dynamic "liveness_probe" {
            for_each = var.liveness_probe_enabled == true ? [1] : []
            content {
              http_get {
                path = var.liveness_probe_path
                port = var.container_port
              }
              initial_delay_seconds = var.liveness_probe_initial_delay_seconds
              period_seconds        = var.liveness_probe_period_seconds
              timeout_seconds       = var.liveness_probe_timeout_seconds
              success_threshold     = var.liveness_probe_success_threshold
              failure_threshold     = var.liveness_probe_failure_threshold
            }
          }

        }
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secrets_enabled == true ? [1] : []
          content {
            name = var.image_pull_secrets
          }
        }
      }
    }
  }
}
