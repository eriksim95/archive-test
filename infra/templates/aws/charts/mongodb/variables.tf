## Common variables
variable "region" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "cluster_oidc_provider" {
  type = string
}
variable "vpc_id" {
  type = string
}


variable "mongodb_cluster_enabled" {
  description = "Whether to deploy the MongoDB Cluster chart"
  type        = bool
  default     = true
}

variable "mongodb_cluster_release_name" {
  description = "Name of the MongoDB Cluster Helm release"
  type        = string
  default     = "mongodb-cluster"
}

variable "mongodb_cluster_namespace" {
  description = "Kubernetes namespace for MongoDB Cluster"
  type        = string
  default     = "mongodb-cluster"
}

variable "mongodb_cluster_chart_version" {
  description = "Version of the MongoDB Cluster Helm chart"
  type        = string
  default     = "15.6.14"
}

variable "mongodb_cluster_values_override" {
  description = "YAML string to override MongoDB Cluster Helm values"
  type        = string
  default     = ""
}