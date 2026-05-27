output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "VPC ARN."
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs by availability zone."
  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs by availability zone."
  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private route table IDs."
  value = {
    for key, route_table in aws_route_table.private :
    key => route_table.id
  }
}

output "internet_gateway_id" {
  description = "Internet gateway ID."
  value       = var.enable_internet_gateway ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs."
  value = {
    for key, nat_gateway in aws_nat_gateway.this :
    key => nat_gateway.id
  }
}

output "flow_log_id" {
  description = "VPC Flow Log ID."
  value       = aws_flow_log.this.id
}

output "flow_logs_log_group_name" {
  description = "CloudWatch Logs group name for VPC Flow Logs."
  value       = aws_cloudwatch_log_group.flow_logs.name
}

output "availability_zones" {
  description = "Availability zones used by the module."
  value       = var.availability_zones
}
