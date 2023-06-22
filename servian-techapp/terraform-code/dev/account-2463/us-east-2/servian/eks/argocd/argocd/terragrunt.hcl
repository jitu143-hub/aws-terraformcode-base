terraform {
  source = "${path_relative_from_include()}"
}

include {
  path = find_in_parent_folders()
}

dependency "argocd-namespace" {
  config_path = "../argocd-namespace"
  skip_outputs = true
}

inputs = {
}