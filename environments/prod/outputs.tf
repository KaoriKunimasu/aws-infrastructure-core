output "environment_name" {
  description = "Environment name."
  value       = var.environment
}

output "vpc_id" {
  description = "VPC ID for the production environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "flow_log_group_name" {
  description = "CloudWatch log group name for VPC Flow Logs."
  value       = module.vpc.flow_logs_log_group_name
}
