locals{
  my_account_conf   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  my_region_conf    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  my_stack_conf     = read_terragrunt_config(find_in_parent_folders("stack.hcl", "fallback.hcl"))
  state_bucket_name = "test-${local.my_account_conf.locals.my_account}-tf"
}

generate "aws_provider" {
  path      = "aws_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.my_region_conf.locals.my_region}"
}
  EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = local.state_bucket_name

    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "${local.my_region_conf.locals.my_region}"
    encrypt = true
  }
}