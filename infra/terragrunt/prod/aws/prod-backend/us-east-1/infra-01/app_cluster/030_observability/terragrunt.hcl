terraform {
  source = "${get_repo_root()}/infra/templates/aws/charts/observability"
}

# For Inputs
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

# For AWS provider & tfstate S3 backand
include "cloud" {
  path = find_in_parent_folders("cloud.hcl")
}

# For Helm, Kubectl & GitHub providers
include "common_providers" {
  path = find_in_parent_folders("providers.hcl")
}

dependency "eks" {
  config_path  = "../010_eks"
  mock_outputs = {
    vpc_id              = "vpc-1234"
    eks_cluster_name    = "test_cluster"
    eks_oidc_provider   = "arn::test"
    eks_oidc_issuer_url = "https://"
  }
}

dependency "system_charts"{
  config_path = "../020_system_charts"
  skip_outputs = true
}

inputs = {
  cluster_region                                  = dependency.eks.outputs.eks_region
  cluster_name                                    = dependency.eks.outputs.eks_cluster_name
  vpc_id                                          = dependency.eks.outputs.vpc_id
  cluster_oidc_provider                           = dependency.eks.outputs.eks_oidc_provider

  # prom stack
  prom_stack_enabled                              = true
  prom_stack_namespace                            = "monitoring"
  prom_stack_serviceaccount                       = "prom-stack"
  prom_stack_ingress_enabled                      = true
  prom_stack_ingress_group_name                   = "system-internal"
  prom_stack_prometheus_server_volume_size        = "10Gi"
  prom_stack_prometheus_alert_manager_volume_size = "10Gi" 
  
  # Elasticsearch
  elasticsearch_enabled                           = true
  elasticsearch_namespace                         = "logging"
  elasticsearch_chart_version                     = "17.3.3"

  # Kibana
  kibana_enabled                                  = true
  kibana_namespace                                = "logging"
  kibana_chart_version                            = "6.1.4"

  # Filebeat
  filebeat_enabled                                = true
  filebeat_namespace                              = "logging"
  filebeat_chart_version                          = "7.17.4"
}
