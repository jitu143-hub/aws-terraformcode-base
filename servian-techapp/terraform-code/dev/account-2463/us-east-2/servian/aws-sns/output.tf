output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.snstopic_rds.arn
}