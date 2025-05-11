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

variable "volume_enabled" {
  type    = bool
  default = false
}

variable "volumes" {
  description = "List of volumes to mount with their configurations"
  type = list(object({
    name       = string
    mount_path = string
    sub_path = optional(string)
    volume_source = object({
      type = string # Can be "persistent_volume_claim", "config_map", "secret", "empty_dir"

      claim_name = optional(string)

      config_map_name = optional(string)
      config_map_items = optional(list(object({
        key  = string
        path = string
      })), [])

      secret_name = optional(string)
      secret_items = optional(list(object({
        key  = string
        path = string
      })), [])

      medium     = optional(string, "")
      size_limit = optional(string, "")
    })
  }))
  default = []
}

variable "volume_name" {
  type    = string
  default = ""
}

variable "persistent_volume_claim_name" {
  type    = string
  default = ""
}

variable "volume_mount_path" {
  type    = string
  default = ""
}

variable "runtime_class_name" {
  description = "The name of the runtime class to use for the pod"
  type        = string
  default     = null
}
