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