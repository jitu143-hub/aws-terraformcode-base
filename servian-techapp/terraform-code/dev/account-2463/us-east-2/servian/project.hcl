locals {
  #VPC
  cidr= "10.10.0.0/16"

  project_name = "servian"
  key_name = "key-pair-servian-us-east-2-dev"

  #route53
  domain_name = "<changeme>"

  # EKS Cluster
  eks_cluster_name= "servian-cluster"
  eks_version = "1.20"


  # Cluster node
  eks_node_desired_size = "1"
  eks_node_max_size = "10"
  eks_node_min_size = "1"
  eks_node_disk_size = "30"
  eks_node_instance_types = "t2.medium"
  eks_node_group_name = "servian-node-group"
  eks_node_key_pair = "key-pair-servian-us-east-2-dev"

  #Vault
  vault_version_constraint = "~> 2.18"
  vault_url    = "https://<changeme>"

  #Cluster autoscaler
  autoscalar_name = "servian-cluster-autoscaler"
  oidc_provider ="<changeme>"

  #AWS SNS endpoint as email address
  sns_endpoint= "<changeme>"
}


