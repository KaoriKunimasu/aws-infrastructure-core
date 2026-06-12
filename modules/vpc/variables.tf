variable "name" {
  description = "Base name used for VPC resources."
  type        = string
}

variable "environment" {
  description = "Environment name used for resource naming and tagging."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used for subnet placement."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets. Must align with availability_zones."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets. Must align with availability_zones."
  type        = list(string)
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Assign public IPv4 addresses to instances launched in public subnets."
  type        = bool
  default     = true
}

variable "enable_internet_gateway" {
  description = "Create an internet gateway for the VPC."
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Create NAT gateway resources for outbound internet access from private subnets."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Create a single shared NAT gateway when enable_nat_gateway is true."
  type        = bool
  default     = true
}

variable "flow_logs_retention_in_days" {
  description = "Retention period for VPC Flow Logs in CloudWatch Logs."
  type        = number
  default     = 30
}

variable "flow_logs_traffic_type" {
  description = "Traffic type captured by VPC Flow Logs."
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "ACCEPT", "REJECT"], var.flow_logs_traffic_type)
    error_message = "flow_logs_traffic_type must be one of: ALL, ACCEPT, REJECT."
  }
}

variable "flow_logs_max_aggregation_interval" {
  description = "Maximum aggregation interval for VPC Flow Logs."
  type        = number
  default     = 60

  validation {
    condition     = contains([60, 600], var.flow_logs_max_aggregation_interval)
    error_message = "flow_logs_max_aggregation_interval must be 60 or 600."
  }
}

variable "tags" {
  description = "Common tags applied to all resources in the module."
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags applied only to public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags applied only to private subnets."
  type        = map(string)
  default     = {}
}

variable "enable_ssm_endpoints" {
  description = "Create interface VPC endpoints (ssm, ssmmessages, ec2messages) so private instances can use SSM without NAT or internet access."
  type        = bool
  default     = false
}
