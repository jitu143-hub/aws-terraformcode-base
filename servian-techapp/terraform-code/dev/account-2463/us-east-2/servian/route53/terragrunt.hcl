locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region = local.region_vars.locals.aws_region

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  domain_name = local.project_vars.locals.domain_name

}

terraform {
  source = "${path_relative_from_include()}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    aws_region = local.aws_region
    domain_name = local.domain_name

}