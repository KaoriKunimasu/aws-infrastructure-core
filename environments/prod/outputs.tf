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

output "operations_instance_id" {
  description = "ID of the production operations instance."
  value       = try(aws_instance.operations[0].id, null)
}

output "operations_instance_private_ip" {
  description = "Private IP address of the production operations instance."
  value       = try(aws_instance.operations[0].private_ip, null)
}

output "operations_security_group_id" {
  description = "Security group ID attached to the production operations instance."
  value       = try(aws_security_group.operations_instance[0].id, null)
}

output "operations_instance_role_name" {
  description = "IAM role name used by the production operations instance."
  value       = try(aws_iam_role.operations_instance[0].name, null)
}
    