variables {
  ingress_enabled         = false
  service_enabled         = true
  app_name                = "some-app"
  namespace               = "some-namespace"
  app_docker_image        = "busybox"
  readiness_probe_enabled = false
  liveness_probe_enabled  = false
  service_port            = 123
  container_port          = 321
  service_type            = "NodePort"
}

run "it deploys service for app in k8s" {
  command = plan

  assert {
    condition = kubernetes_service.main[0].metadata[0].name == "some-app"

    error_message = "Service name was not passed correctly"
  }
  assert {
    condition = kubernetes_service.main[0].metadata[0].namespace == "some-namespace"

    error_message = "Service namespace was not passed correctly"
  }
  assert {
    condition = kubernetes_service.main[0].spec[0].selector.app == "some-app"

    error_message = "Service selector was not passed correctly"
  }
  assert {
    condition = kubernetes_service.main[0].spec[0].port[0].port == 123

    error_message = "Service port was not passed correctly"
  }
  assert {
    condition = kubernetes_service.main[0].spec[0].port[0].target_port == "321"

    error_message = "Service target port was not passed correctly"
  }
  assert {
    condition = kubernetes_service.main[0].spec[0].type == "NodePort"

    error_message = "Service type was not passed correctly"
  }
}
