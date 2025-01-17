terraform {
  source = "${get_repo_root()}/infra/templates/aws/eks"
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

dependency "vpc" {
  config_path  = "../../vpc"
  mock_outputs = {
    vpc_id             = "vpc-1234"
    vpc_cidr_block     = "10.0.0.0/16"
    public_subnets     = ["subnet-1", "subnet-2", "subnet-3"]
    private_subnets    = ["subnet-4", "subnet-5", "subnet-6"]
  }
}

locals {
  my_env               = include.root.locals.my_env_conf.locals.my_env
  my_stack             = include.root.locals.my_stack_conf.locals.my_stack
  cluster_name         = "eks-${local.my_env}"
}

inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id
  vpc_cidr_block        = dependency.vpc.outputs.vpc_cidr_block
  public_subnet_ids     = dependency.vpc.outputs.public_subnets
  private_subnet_ids    = dependency.vpc.outputs.private_subnets
  environment           = local.my_env
  cluster_name          = local.cluster_name
  kubernets_version     = "1.30"
  stack_name            = local.my_stack
  tags                  = include.root.inputs.common_tags
  
  kubernetes_nodes_default_release_version = "1.30.0-20240703"
  eks_managed_node_groups = {
    app_test = {
      desired_size = 1
      min_size     = 1
      max_size     = 10
      labels = {
        role = "app"
      }
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
    data = {
      desired_size = 1
      min_size     = 1
      max_size     = 10
      subnet_ids   = [dependency.vpc.outputs.private_subnets[0]]
      labels = {
        role = "data"
      }
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }    
  }
}

