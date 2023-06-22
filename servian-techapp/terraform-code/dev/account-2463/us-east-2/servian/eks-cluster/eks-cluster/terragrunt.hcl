locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.environment_vars.locals.environment

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  local_dir = local.account_vars.locals.local_dir
  aws_account_id = local.account_vars.locals.aws_account_id
  aws_account_short_id = local.account_vars.locals.aws_account_short_id
  account_name = local.account_vars.locals.account_name

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region = local.region_vars.locals.aws_region

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project_name = local.project_vars.locals.project_name
  eks_cluster_name = local.project_vars.locals.eks_cluster_name
  eks_version = local.project_vars.locals.eks_version
  eks_node_group_name = local.project_vars.locals.eks_node_group_name
  eks_node_key_pair = local.project_vars.locals.eks_node_key_pair
}

terraform {
  source = "${path_relative_from_include()}"
}

include {
  path = find_in_parent_folders()
}

dependency "security-groups" {
  config_path = "../../security-group/sg-nodes"
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
    env_name = local.env_name
    local_dir = local.local_dir
    aws_region = local.aws_region
    aws_account_id = local.aws_account_id
    aws_account_short_id = local.aws_account_short_id
    project_name = local.project_name
    eks_cluster_name = local.eks_cluster_name
    eks_version= local.eks_version
    eks_node_group_name= local.eks_node_group_name
    eks_node_key_pair = local.eks_node_key_pair
    account_name = local.account_name
  map_users = [
    {
      userarn = "arn:aws:iam::${local.aws_account_id}:user/riyaj.kazi@gmail.com" # changeme
      username = "riyaj.kazi@gmail.com" # changeme
      groups = [
        "system:masters"
      ]
    }

  ]
}