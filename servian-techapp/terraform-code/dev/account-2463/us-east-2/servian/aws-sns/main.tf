
resource "aws_sns_topic" "snstopic_rds" {
  name = "sns-for-rds-${var.project_name}"
}

resource "aws_sns_topic_subscription" "rds_subscription" {
  topic_arn = aws_sns_topic.snstopic_rds.arn
  protocol  = "email"
  endpoint  = var.sns_endpoint
  endpoint_auto_confirms = true
}
