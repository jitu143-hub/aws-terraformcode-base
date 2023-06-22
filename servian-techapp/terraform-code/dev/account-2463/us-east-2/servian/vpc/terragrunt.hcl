locals {
# Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  # Automatically load project level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
  region_short_id = local.region_vars.locals.aws_region_short_id
  account_short_id = local.account_vars.locals.aws_account_short_id
  project_name = local.project_vars.locals.project_name
  cidr = local.project_vars.locals.cidr
}

terraform {
  source = "/mnt/c/personal/MT/servian-techapp/iac-module-aws/vpc"
}


include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../aws-data"]
}

dependency "aws-data" {
  config_path = "../aws-data"
}

###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.18.0?tab=inputs
###########################################################
inputs = {
  # A list of availability zones in the region
  # type: list(string)
  azs = [for v in dependency.aws-data.outputs.available_aws_availability_zones_names: v]

  # The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
  # type: string
  cidr = local.cidr

  # A list of database subnets
  # type: list(string)
  database_subnets = [for k,v in dependency.aws-data.outputs.available_aws_availability_zones_names: cidrsubnet(local.cidr, 11, k+24)]

  # Name to be used on all the resources as identifier
  # type: string
  name = "vpc-${local.project_name}-${local.env}-${local.region_short_id}-${local.account_short_id}"

  # A list of private subnets inside the VPC
  # type: list(string)
  private_subnets = [for k,v in dependency.aws-data.outputs.available_aws_availability_zones_names: cidrsubnet(local.cidr, 11, k+16)]

  # A list of public subnets inside the VPC
  # type: list(string)
  public_subnets = [for k,v in dependency.aws-data.outputs.available_aws_availability_zones_names: cidrsubnet(local.cidr, 11, k+8)]

  enable_nat_gateway = true
  single_nat_gateway  = true
  enable_dns_hostnames = true
  enable_dns_support   = true

}
