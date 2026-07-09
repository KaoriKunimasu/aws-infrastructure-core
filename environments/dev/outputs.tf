output "environment_name" {
  description = "The name of the environment."
  value       = var.environment
}

output "aws_account_id" {
  description = "The AWS account ID where the infrastructure is deployed."
  value       = data.aws_caller_identity.current.account_id
}

output "vpc_id" {
  description = "The ID of the VPC created for the dev environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets created for the dev environment."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets by availability zone."
  value       = module.vpc.private_subnet_ids
}

output "flow_logs_log_group_name" {
  description = "The name of the CloudWatch Logs log group for VPC flow logs."
  value       = module.vpc.flow_logs_log_group_name
}

output "dev_instance_id" {
  description = "The ID of the EC2 instance created for validation in the dev environment."
  value       = aws_instance.dev_validation.id
}

output "dev_instance_private_ip" {
  description = "The private IP address of the EC2 instance created for validation in the dev environment."
  value       = aws_instance.dev_validation.private_ip
}

output "ssm_start_session_command" {
  description = "The AWS CLI command to start an SSM session to the dev validation instance."
  value       = "aws ssm start-session --target ${aws_instance.dev_validation.id}"
}

output "alarm_topic_arn" {
  description = "The ARN of the SNS topic for CloudWatch alarms, if notifications are enabled."
  value       = local.notifications_enabled ? aws_sns_topic.alerts[0].arn : null
}
output "cpu_alarm_name" {
  description = "CloudWatch alarm namefor high CPU utilization on the dev instance."
  value       = aws_cloudwatch_metric_alarm.dev_instance_cpu_high.alarm_name
}

output "monthly_budget_name" {
  description = "The name of the monthly budget created for the dev environment."
  value       = local.notifications_enabled ? aws_budgets_budget.dev_monthly[0].name : null
}