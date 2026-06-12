variable "aws_region" {
  description = "AWS region used for the dev environment"
  type        = string
  default     = "ap-southeast-2"
}

variable "allowed_account_ids" {
  description = "Optional AWS account IDs allowed for this configuration."
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the dev VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used in the dev environment."
  type        = list(string)
  default = [
    "ap-southeast-2a",
    "ap-southeast-2b"
  ]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks used for dev public subnets."
  type        = list(string)
  default = [
    "10.10.0.0/24",
    "10.10.1.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks used for dev private subnets."
  type        = list(string)
  default = [
    "10.10.10.0/24",
    "10.10.11.0/24"
  ]
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway creation for the dev environment."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Create a single shared NAT gateway when enable_nat_gateway is true."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type used for dev environment."
  type        = string
  default     = "t3.micro"
}

variable "instance_volume_size" {
  description = "Size of the root EBS volume for EC2 instances in GB."
  type        = number
  default     = 8
}

variable "notification_email" {
  description = "Email address to receive notifications. Leave empty to disable email notifications."
  type        = string
  default     = ""
}

variable "monthly_budget_limit" {
  description = "Monthly budget limit in USD for the dev environment. Set to 0 to disable budget alerts."
  type        = number
  default     = 10
}