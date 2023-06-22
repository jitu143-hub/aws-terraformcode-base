terraform {

  source = "/mnt/c/personal/MT/servian-techapp/iac-module-aws/aws-data"
}

include {
  path = find_in_parent_folders()
}

inputs = {}
