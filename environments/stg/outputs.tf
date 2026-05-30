output "environment_name" {
  description = "The name of the environment."
  value       = var.environment
}

output "vpc_id" {
  description = "The ID of the VPC created for the staging environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets created for the staging environment."
  value       = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  description = "The IDs of the private subnets created for the staging environment."
  value       = module.vpc.private_subnet_ids
}

output "flow_logs_log_group_name" {
  description = "The name of the CloudWatch Logs log group for VPC flow logs."
  value       = module.vpc.flow_logs_log_group_name
}

output "validation_instance_id" {
  description = "The ID of the EC2 instance created for validation in the staging environment."
  value       = try(aws_instance.validation[0].id, null)
}

output "validation_instance_private_ip" {
  description = "The private IP address of the EC2 instance created for validation in the staging environment."
  value       = try(aws_instance.validation[0].private_ip, null)
}

output "validation_security_group_id" {
  description = "The ID of the security group attached to the staging validation instance."
  value       = try(aws_security_group.validation_instance[0].id, null)
}

output "validation_instance_role_name" {
  description = "The name of the IAM role attached to the staging validation instance."
  value       = try(aws_iam_role.validation_instance[0].name, null)
}

output "alerts_topic_arn" {
  description = "SNS topic ARN used for staging alerts."
  value       = aws_sns_topic.alerts.arn
}

output "validation_cpu_alarm_name" {
  description = "CloudWatch alarm name for the staging validation instance CPU alarm."
  value       = try(aws_cloudwatch_metric_alarm.validation_cpu_high[0].alarm_name, null)
}

output "monthly_budget_arn" {
  description = "ARN of the staging monthly budget."
  value       = aws_budgets_budget.monthly.arn
}
