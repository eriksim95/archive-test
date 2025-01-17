terraform {
  source = "${get_repo_root()}/infra/templates/aws/charts/system_charts"
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
  }
}

locals {
  my_region = include.root.locals.my_region_conf.locals.my_region
}

inputs = {
  region                                       = local.my_region
  cluster_name                                 = dependency.eks.outputs.eks_cluster_name
  vpc_id                                       = dependency.eks.outputs.vpc_id
  cluster_oidc_provider                        = dependency.eks.outputs.eks_oidc_provider
           
  # EBS CSI Driver
  ebs_csi_enabled                              = true
  ebs_csi_driver_namespace                     = "kube-system"

  # Metrics Server
  metrics_server_enabled                       = true
  metrics_server_namespace                     = "kube-system"

  # Cluster Autoscaler           
  cluster_autoscaler_enabled                   = true
  cluster_autoscaler_namespace                 = "cluster-autoscaler"  
}