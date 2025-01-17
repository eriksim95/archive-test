terraform {
  source = "${get_repo_root()}/infra/templates/aws/charts/mongodb"
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
    eks_endpoint        = "https://example.com/eks"
    eks_cluster_name    = "test_cluster"
    eks_oidc_provider   = "arn::test"
    eks_oidc_issuer_url = "https://"
    }
}

locals {
  my_region         = include.root.locals.my_region_conf.locals.my_region
}

inputs = {
  region                                   = local.my_region
  cluster_name                             = dependency.eks.outputs.eks_cluster_name
  vpc_id                                   = dependency.eks.outputs.vpc_id
  cluster_oidc_provider                    = dependency.eks.outputs.eks_oidc_provider

  mongodb_cluster_enabled                 = true
  mongodb_cluster_namespace               = "mongodb-cluster"
  mongodb_cluster_chart_version           = "15.6.14"
  mongodb_cluster_values_override         = <<EOT
resourcesPreset: medium
persistence:
  size: 2Gi
EOT
}
