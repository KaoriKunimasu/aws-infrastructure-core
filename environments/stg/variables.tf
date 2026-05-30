variable "aws_region" {
  description = "AWS region used for the staging environment"
  type        = string
  default     = "ap-southeast-2"
}

variable "allowed_account_ids" {
  description = "Optional AWS account IDs allowed for this configuration."
  type        = list(string)
  default     = []
}

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
  default     = "core-infrastructure"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "stg"
}

variable "cost_center" {
  description = "Cost center for billing and tagging purposes."
  type        = string
  default     = "platform-engineering"
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "platform-team"
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the staging VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "availability_zones" {
  description = "Availability zones used in the staging environment."
  type        = list(string)
  default = [
    "ap-southeast-2a",
    "ap-southeast-2b"
  ]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks used for staging public subnets."
  type        = list(string)
  default = [
    "10.20.0.0/24",
    "10.20.1.0/24"
  ]
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks used for staging private subnets."
  type        = list(string)
  default = [
    "10.20.10.0/24",
    "10.20.11.0/24"
  ]
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway creation for the staging environment."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway for the staging environment."
  type        = bool
  default     = true
}

variable "flow_logs_retention_in_days" {
  description = "Number of days to retain VPC flow logs in CloudWatch Logs."
  type        = number
  default     = 30
}