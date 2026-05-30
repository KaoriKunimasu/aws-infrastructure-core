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

variable "create_operations_instance" {
  description = "Whether to create the production operations instance."
  type        = bool
  default     = false
}

variable "operations_instance_type" {
  description = "EC2 instance type for the production operations instance."
  type        = string
  default     = "t3.small"
}

variable "operations_root_volume_size" {
  description = "Root volume size in GiB for the production operations instance."
  type        = number
  default     = 20
}

variable "operations_private_subnet_index" {
  description = "Private subnet index used for the production operations instance."
  type        = number
  default     = 0
}

variable "notification_email" {
  description = "Optional email address subscribed to the production alerts SNS topic."
  type        = string
  default     = ""
}

variable "cpu_alarm_threshold" {
  description = "CPU utilization threshold for the production operations instance alarm."
  type        = number
  default     = 60
}

variable "cpu_alarm_period_seconds" {
  description = "Period in seconds for the production operations instance CPU alarm."
  type        = number
  default     = 300
}

variable "cpu_alarm_evaluation_periods" {
  description = "Number of evaluation periods for the production operations instance CPU alarm."
  type        = number
  default     = 2
}

variable "monthly_budget_limit" {
  description = "Monthly budget limit for the production environment."
  type        = number
  default     = 150
}

variable "budget_limit_unit" {
  description = "Budget limit unit."
  type        = string
  default     = "USD"
}

variable "budget_actual_threshold" {
  description = "Actual spend percentage threshold for budget notifications."
  type        = number
  default     = 80
}

variable "budget_forecast_threshold" {
  description = "Forecasted spend percentage threshold for budget notifications."
  type        = number
  default     = 100
}
