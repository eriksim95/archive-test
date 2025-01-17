# prom_stack
variable "prom_stack_enabled" {
  type    = bool
  default = false
}
variable "prom_stack_namespace" {
  type    = string
  default = "monitoring"
}
variable "prom_stack_serviceaccount" {
  type    = string
  default = "prom_stack"
}

variable "prom_stack_ingress_enabled" {
  type    = bool
  default = false
}

variable "prom_stack_ingress_group_name" {
  type    = string
  default = ""
}

variable "prom_stack_prometheus_server_volume_size" {
  type    = string
  default = "20Gi"
}

variable "prom_stack_prometheus_alert_manager_volume_size" {
  type    = string
  default = "5Gi"
}

variable "refresh_interval" {
  type        = string
  default     = "10s"
  description = "Secret refresh interval"
}

variable "creation_policy" {
  type        = string
  default     = "Owner"
  description = "creation policy"
}

variable "secretKey" {
  type        = string
  default     = ""
  description = "secretKey reference"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}