variable "env_name" {
  type        = string
  description = "Type of environment ex: dev, stage or prod"
}

variable "local_dir" {
  type        = string
  description = "local account directory name"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "aws_account_id" {
  type        = string
  description = "aws account id"
}
variable "project_name" {
  type        = string
  description = "project name"
}
variable "aws_account_short_id" {
  type        = string
  description = "aws account short id"
}
variable "eks_cluster_name" {
  type        = string
  description = "eks cluster name"
}
variable "eks_version" {
  type        = string
  description = "eks version"
}
variable "eks_node_group_name" {
  type        = string
  description = "eks node group name"
}
variable "eks_node_key_pair" {
  type        = string
  description = "eks node key pair"
}
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

}
variable "account_name" {
  type = string
  description = "account name"
}