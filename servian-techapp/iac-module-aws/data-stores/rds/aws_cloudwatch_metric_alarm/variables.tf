variable "create_metric_alarm" {
  description = "Whether to create the Cloudwatch metric alarm"
  type        = bool
}

variable "alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account."
  type        = string
}

variable "threshold" {
  description = "The value against which the specified statistic is compared."
  type        = number
}

variable "identifier" {
  description = "The name of the RDS instance, DBInstanceIdentifier."
  type        = string
}

variable "aws_sns_arn" {
  description = "The arn of the AWS SNS."
  type        = string
}