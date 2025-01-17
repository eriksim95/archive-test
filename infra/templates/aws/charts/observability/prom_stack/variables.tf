variable "name" {
  type        = string
  description = "Name of release"
  default     = "kube-prom-stack"
}

variable "namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "monitoring"
}

variable "chart_version" {
  type        = string
  description = "Helm chart to release"
  default     = "61.5.0"
}

variable "enabled" {
  type        = bool
  description = "Enable or not chart as a component"
  default     = false
}

variable "extra_values" {
  type        = map(any)
  description = "Extra values in key value format"
  default     = {}
}

variable "serviceaccount" {
  type        = string
  description = "Serviceaccount name"
  default     = "prom-stack"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}


variable "ingress_enabled" {
  type        = bool
  default     = false
  description = "Enable or not ingress"
}

variable "ingress_group_name" {
  type        = string
  default     = ""
  description = "Resuse same ALB by specifying the same ALB group name"
}

variable "prometheus_server_volume_size" {
  type        = string
  default     = "20Gi"
  description = "Size of EBS volume for prometheus server"
}

variable "prometheus_alert_manager_volume_size" {
  type        = string
  default     = "5Gi"
  description = "Size of EBS volume for prometheus alert manager"
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
