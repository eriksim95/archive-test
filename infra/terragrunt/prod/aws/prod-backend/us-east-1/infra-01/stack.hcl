locals {
  my_stack       = basename(get_terragrunt_dir())
  my_region_conf = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  my_env_conf    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  
}