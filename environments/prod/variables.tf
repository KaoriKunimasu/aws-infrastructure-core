variable "aws_region" {
  description = "AWS region used for the production environment"
  type        = string
  default     = "ap-southeast-2"
}

variable "allowed_account_ids" {
  description = "Optional AWS account IDs allowed for safety checks."
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
  default     = "prod"
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
  description = "CIDR block assigned to the production VPC"
  type        = string
  default     = "10.30.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used in the production environment."
  type        = list(string)
  default = [
    "ap-southeast-2a",
    "ap-southeast-2b"
  ]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks used for production public subnets."
  type        = list(string)
  default = [
    "10.30.0.0/24",
    "10.30.1.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks used for production private subnets."
  type        = list(string)
  default = [
    "10.30.10.0/24",
    "10.30.11.0/24"
  ]
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway creation for the production environment."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway for the production environment."
  type        = bool
  default     = true
}

variable "flow_logs_retention_in_days" {
  description = "Number of days to retain VPC flow logs. Set to 0 for indefinite retention."
  type        = number
  default     = 90
}