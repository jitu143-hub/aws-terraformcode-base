resource "aws_cloudwatch_metric_alarm" "this" {

  count = var.create_metric_alarm ? 1 : 0

  alarm_name                = var.alarm_name
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "3"
  datapoints_to_alarm       = "3"
  threshold                 = var.threshold
  alarm_description         = "Notify when free storage space is less than threshold"
  insufficient_data_actions = []
  alarm_actions = [var.aws_sns_arn]
  ok_actions = [var.aws_sns_arn]
  dimensions = {
    DBInstanceIdentifier = var.identifier
  }
  metric_name = "FreeStorageSpace"
  namespace = "AWS/RDS"
  period = "300"
  treat_missing_data = "missing"
  statistic = "Average"
}
