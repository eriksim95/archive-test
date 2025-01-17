terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.9.0"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "cloud" {
  path = find_in_parent_folders("cloud.hcl")
}

locals {
  my_env       = include.root.locals.my_env_conf.locals.my_env
  my_region    = include.root.locals.my_region_conf.locals.my_region
  my_account   = include.root.locals.my_account_conf.locals.my_account
}

inputs = {
  name                = "${local.my_account}-vpc"
  cidr                = "10.0.0.0/16"
  azs                 = ["${local.my_region}a", "${local.my_region}b", "${local.my_region}c"]
  private_subnets     = ["10.0.0.0/18", "10.0.64.0/18", "10.0.128.0/18"]
  private_subnet_tags = { "PrivateSubnet" = "true", "kubernetes.io/role/internal-elb" = 1 }
  public_subnets      = ["10.0.192.0/20", "10.0.208.0/20", "10.0.224.0/20"]
  public_subnet_tags  = { "PublicSubnet" = "true", "kubernetes.io/role/elb" = 1 }

  enable_nat_gateway      = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  tags = merge(
    include.root.inputs.common_tags,
    {
      infra = true
    }
  )
}