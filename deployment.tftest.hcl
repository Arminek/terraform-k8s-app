variables {
  ingress_enabled         = false
  service_enabled         = false
  app_name                = "some-app"
  namespace               = "some-namespace"
  app_docker_image        = "busybox"
  readiness_probe_enabled = false
  liveness_probe_enabled  = false
  envs_from_value = [
    {
      name  = "SOME_ENV"
      value = "some-value"
    }
  ]
  envs_from_secrets = [
    {
      name        = "SOME_SECRET_ENV"
      secret_name = "some-secret"
      secret_key  = "some-key"
    }
  ]
  envs_from_configmaps = [
    {
      name        = "SOME_CONFIG_ENV"
      config_name = "some-config"
      config_key  = "config-key"
    }
  ]
}

run "it creates deployment for app in k8s" {
  command = plan

  assert {
    condition = kubernetes_deployment.main.metadata[0].name == "some-app"

    error_message = "Deployment name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.metadata[0].namespace == "some-namespace"

    error_message = "Deployment namespace is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].image == "busybox"

    error_message = "Deployment image is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].name == "some-app"

    error_message = "Deployment container name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].env[0].name == "SOME_ENV"

    error_message = "Deployment value env name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].env[0].value == "some-value"

    error_message = "Deployment value env name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].env[1].name == "SOME_SECRET_ENV"

    error_message = "Deployment secret env name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].env[1].value_from[0].secret_key_ref[0].name == "some-secret"

    error_message = "Deployment secret env name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].env[1].value_from[0].secret_key_ref[0].key == "some-key"

    error_message = "Deployment secret env name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].env[2].value_from[0].config_map_key_ref[0].name == "some-config"

    error_message = "Deployment config env name is not correct"
  }
  assert {
    condition = kubernetes_deployment.main.spec[0].template[0].spec[0].container[0].env[2].value_from[0].config_map_key_ref[0].key == "config-key"

    error_message = "Deployment config env name is not correct"
  }
}
