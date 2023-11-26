K8s app
=======
This is a simple terraform module to deploy a k8s application.

Requirements
------------
- Terraform `>= 1.5.0`
- Kubernetes provider `>= 2.18.0`

Usage
-----
```hcl
module "app" {
  source           = "app.terraform.io/rocket-arminek/app/k8s"
  app_name         = "your-app-name"
  namespace        = "your-namespace"
  app_docker_image = "your-docker-image"
  replicas         = 2

  hosts     = ["subdomain.your-domain.xyz"]
  tls_hosts = ["subdomain.your-domain.xyz"]
  ingress_annotations = {
    "kubernetes.io/ingress.class" : "traefik"
    "cert-manager.io/cluster-issuer" : "letsencrypt"
  }

  resources_limits = {
    "cpu"    = "1"
    "memory" = "128Mi"
  }
  resources_requests = {
    "cpu"    = "250m"
    "memory" = "64Mi"
  }

  liveness_probe_path                  = "/v1/health"
  liveness_probe_initial_delay_seconds = 60
  liveness_probe_period_seconds        = 60

  readiness_probe_path                  = "/v1/health"
  readiness_probe_initial_delay_seconds = 1
  readiness_probe_period_seconds        = 10

  pdb_enabled = true

  image_pull_secrets = "github-registry"
  node_selector = {
    "purpose" = "workload"
  }
}
```

Inputs
------
```hcl
variable "namespace" {
  description = "Namespace to deploy to"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "env" {
  description = "Environment labels"
  type        = string
  default     = "prod"
}

variable "app_docker_image" {
  description = "Docker image to deploy"
  type        = string
}

variable "ingress_enabled" {
  description = "Enable ingress"
  type        = bool
  default     = true
}

variable "hosts" {
  description = "Hosts to add to ingress. Example: [\"example.com\", \"www.example.com\"]"
  type        = set(string)
  default     = []
}

variable "tls_hosts" {
  description = "Hosts to add to ingress with TLS. Example: [\"example.com\", \"www.example.com\"]"
  type        = set(string)
  default     = []
}

variable "ingress_annotations" {
  description = "Annotations to add to ingress"
  type        = any
  default     = {}
}

variable "envs_from_value" {
  description = "Environment variables from value"
  type = set(object({
    name  = string
    value = string
  }))
  default = []
}

variable "envs_from_secrets" {
  description = "Environment variables from secrets"
  type = set(object({
    name        = string
    secret_name = string
    secret_key  = string
  }))
  default = []
}

variable "envs_from_configmaps" {
  description = "Environment variables from configmaps"
  type = set(object({
    name        = string
    config_name = string
    config_key  = string
  }))
  default = []
}

variable "wait_for_load_balancer" {
  description = "Wait for load balancer to be ready before continuing"
  type        = bool
  default     = false
}

variable "wait_for_deployment_rollout" {
  description = "Wait for deployment rollout to finish before continuing"
  type        = bool
  default     = false
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "node_selector" {
  description = "Node selector for pod assignment"
  type        = any
  default     = {}
}

variable "image_pull_policy" {
  description = "The image pull policy for the container. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise."
  type        = string
  default     = "IfNotPresent"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "resources_limits" {
  description = "Resources limits"
  type        = any
  default     = {}
}

variable "resources_requests" {
  description = "Resources requests"
  type        = any
  default     = {}
}

variable "image_pull_secrets_enabled" {
  type    = bool
  default = true
}

variable "image_pull_secrets" {
  type    = string
  default = ""
}

variable "service_port" {
  type    = number
  default = 80
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "service_enabled" {
  type    = bool
  default = true
}

variable "readiness_probe_enabled" {
  type    = bool
  default = true
}

variable "readiness_probe_path" {
  type    = string
  default = "/"
}

variable "readiness_probe_initial_delay_seconds" {
  type    = number
  default = 30
}

variable "readiness_probe_period_seconds" {
  type    = number
  default = 10
}

variable "readiness_probe_timeout_seconds" {
  type    = number
  default = 5
}

variable "readiness_probe_success_threshold" {
  type    = number
  default = 1
}

variable "readiness_probe_failure_threshold" {
  type    = number
  default = 3
}

variable "liveness_probe_enabled" {
  type    = bool
  default = true
}

variable "liveness_probe_path" {
  type    = string
  default = "/"
}

variable "liveness_probe_initial_delay_seconds" {
  type    = number
  default = 30
}

variable "liveness_probe_period_seconds" {
  type    = number
  default = 10
}

variable "liveness_probe_timeout_seconds" {
  type    = number
  default = 5
}

variable "liveness_probe_success_threshold" {
  type    = number
  default = 1
}

variable "liveness_probe_failure_threshold" {
  type    = number
  default = 3
}

variable "hpa_enabled" {
  type    = bool
  default = false
}

variable "pdb_enabled" {
  type    = bool
  default = false
}

variable "pdb_max_unavailable" {
  type    = string
  default = "50%"
}
```