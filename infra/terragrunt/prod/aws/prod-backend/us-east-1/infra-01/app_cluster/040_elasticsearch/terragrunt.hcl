terraform {
  source = "${get_repo_root()}/infra/templates/aws/charts/elasticsearch"
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
  # Elasticsearch
  elasticsearch_enabled                           = true
  elasticsearch_namespace                         = "logging"
  elasticsearch_chart_version                     = "19.10.3"


  # Kibana
  kibana_enabled                                  = true
  kibana_namespace                                = "logging"
  kibana_chart_version                            = "11.2.23"

  # Filebeat
  filebeat_enabled                                = true
  filebeat_namespace                              = "logging"
  filebeat_chart_version                          = "8.5.1"

}
