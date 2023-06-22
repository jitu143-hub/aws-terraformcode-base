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
  eks_cluster_name = local.project_vars.locals.eks_cluster_name
  project_name = local.project_vars.locals.project_name
  autoscalar_name = local.project_vars.locals.autoscalar_name
  oidc_provider = local.project_vars.locals.oidc_provider
}

terraform {
  source = "${path_relative_from_include()}"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../../iam/policies/cluster-autoscaler"]
}

dependency "cluster-autoscaler-policy" {
  config_path = "../../../iam/policies/cluster-autoscaler"
}

inputs = {
  role_policy_arn = dependency.cluster-autoscaler-policy.outputs.arn
  autoscalar_name = local.autoscalar_name
  env_name = local.env_name
  oidc_provider = local.oidc_provider
  eks_cluster_name=local.eks_cluster_name
  aws_region =local.aws_region
  namespace = "cluster-autoscaler"
}