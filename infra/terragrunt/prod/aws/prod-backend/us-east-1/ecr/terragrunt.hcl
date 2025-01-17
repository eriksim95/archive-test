terraform {
  source = "${get_repo_root()}/infra/templates/aws/ecr"
}

# For Inputs
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

# For AWS provider & tfstate S3 backand
include {
  path = find_in_parent_folders("cloud.hcl")
}

locals {
  repositories = fileexists("yamls/repositories.yaml") ? yamldecode(file("yamls/repositories.yaml")) : []
}

inputs = {
  repositories                   = local.repositories
  days_to_remove_untagged_images = 10
  pr_image_count                 = 7
  max_image_count                = 50
  tags                           = include.root.inputs.common_tags
}