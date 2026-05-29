resource "aws_sns_topic" "alerts" {
  count = local.notifications_enabled ? 1 : 0
  name  = "${local.name_prefix}-alerts"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alerts"
    }
  )
}

resource "aws_sns_topic_subscription" "email" {
  count     = local.notifications_enabled ? 1 : 0
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "dev_instance_cpu_high" {
  alarm_name          = "${local.name_prefix}-instance-cpu-high"
  alarm_description   = "Alarm when dev validation instance CPU utilization exceeds 80%."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.dev_validation.id
  }

  alarm_actions = local.notifications_enabled ? [aws_sns_topic.alerts[0].arn] : []
  ok_actions    = local.notifications_enabled ? [aws_sns_topic.alerts[0].arn] : []

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance-cpu-high"
    }
  )
}