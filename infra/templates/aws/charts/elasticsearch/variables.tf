# infra/terraform/aws/charts/observability/variables.tf

variable "elasticsearch_enabled" {
  description = "Enable Elasticsearch deployment"
  type        = bool
  default     = true
}

variable "elasticsearch_namespace" {
  description = "Namespace for Elasticsearch"
  type        = string
  default     = "logging"
}

variable "elasticsearch_chart_version" {
  description = "Elasticsearch Helm chart version"
  type        = string
  default     = "17.3.3"
}


variable "kibana_enabled" {
  description = "Enable Kibana deployment"
  type        = bool
  default     = true
}

variable "kibana_namespace" {
  description = "Namespace for Kibana"
  type        = string
  default     = "logging"
}

variable "kibana_chart_version" {
  description = "Kibana Helm chart version"
  type        = string
  default     = "6.1.4"
}


variable "filebeat_enabled" {
  description = "Enable Filebeat deployment"
  type        = bool
  default     = true
}

variable "filebeat_namespace" {
  description = "Namespace for Filebeat"
  type        = string
  default     = "logging"
}

variable "filebeat_chart_version" {
  description = "Filebeat Helm chart version"
  type        = string
  default     = "7.17.4"
}

