## Common
variable "cluster_oidc_provider" {
  description = "The OIDC provider to use for the cluster"
  type        = string
  default     = "oidc.eks.region.amazonaws.com/id/cluster_name:sub"
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to host the cluster in"
  type        = string
}

## Cluster autoscaler
variable "cluster_autoscaler_enabled" {
  type    = bool
  default = false
}

variable "cluster_autoscaler_namespace" {
  type    = string
  default = "kube-system"
}

variable "cluster_autoscaler_serviceaccount" {
  type    = string
  default = "cluster-autoscaler"
}

variable "cluster_autoscaler_extra_values" {
  type    = map(any)
  default = {}
}

## EBS CSI Driver
variable "ebs_csi_enabled" {
  type    = bool
  default = false
}

variable "ebs_csi_driver_namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "kube-system"
}

variable "ebs_csi_driver_serviceaccount" {
  type        = string
  description = "Serviceaccount name"
  default     = "ebs-csi"
}

# Metrics Server
variable "metrics_server_enabled" {
  type    = bool
  default = false
}

variable "metrics_server_namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "kube-system"
}

variable "metrics_server_serviceaccount" {
  type        = string
  description = "Serviceaccount name"
  default     = "metrics-server"
}
