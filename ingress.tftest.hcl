variables {
  ingress_enabled         = true
  service_enabled         = false
  app_name                = "some-app"
  namespace               = "some-namespace"
  app_docker_image        = "busybox"
  readiness_probe_enabled = false
  liveness_probe_enabled  = false
  hosts                   = ["some-app.example.com", "some-app-2.example.com"]
  tls_hosts               = ["some-app.example.com", "*.example.com"]
}

run "it_creates_ingress_for_app_in_k8s" {
  command = plan

  assert {
    condition = kubernetes_ingress_v1.main[0].metadata[0].name == "some-app"

    error_message = "Ingress name is not correct"
  }
  assert {
    condition = kubernetes_ingress_v1.main[0].metadata[0].namespace == "some-namespace"

    error_message = "Ingress namespace is not correct"
  }
  assert {
    condition = kubernetes_ingress_v1.main[0].spec[0].tls[0].hosts[0] == "*.example.com"

    error_message = "Ingress tls hosts are not correct"
  }
  assert {
    condition = kubernetes_ingress_v1.main[0].spec[0].tls[0].hosts[1] == "some-app.example.com"

    error_message = "Ingress tls hosts are not correct"
  }
  assert {
    condition = kubernetes_ingress_v1.main[0].spec[0].rule[0].host == "some-app-2.example.com"

    error_message = "Ingress hosts are not correct"
  }
  assert {
    condition = kubernetes_ingress_v1.main[0].spec[0].rule[1].host == "some-app.example.com"

    error_message = "Ingress hosts are not correct"
  }
  assert {
    condition = kubernetes_ingress_v1.main[0].spec[0].tls[0].secret_name == "some-app-tls"

    error_message = "Ingress tls secret name is not correct"
  }
}
