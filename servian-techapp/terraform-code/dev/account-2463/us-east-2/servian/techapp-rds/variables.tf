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
variable "account_name" {
  type = string
  description = "account name"
}

variable "aws_sns_arn" {
  description = "The arn of the AWS SNS."
  type        = string
}

variable "create_alerts" {
  description = "Whether to create AWS/PagerDuty alerts"
  type        = bool
}