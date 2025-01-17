locals {
  my_env_conf     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  my_account_conf = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  my_region_conf  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  my_stack_conf   = read_terragrunt_config(find_in_parent_folders("stack.hcl", "fallback.hcl"))
}

inputs = {
  common_tags = {
    Terragrunt    = "true"
    Environment   = local.my_env_conf.locals.my_env
  }
}