variable "role_policy_arn" {
  description = "Policy arn"
  type        = string
  default     = ""
}

variable "autoscalar_name" {
  description = "autoscalar name"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC provider"
  type        = string
}

variable "env_name" {
  type        = string
  description = "Type of environment ex: dev, stage or prod"
}

variable "eks_cluster_name" {
  type        = string
  description = "Eks Cluster Name"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "namespace" {
  type        = string
  description = "Namespace Name"
}


