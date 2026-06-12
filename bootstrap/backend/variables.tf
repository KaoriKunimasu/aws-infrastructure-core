variable "aws_region" {
  description = "aws region used for backend bootstrap resources."
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_prefix" {
  description = "Prefix for the name of the S3 bucket to be created for storing terraform state files. The full bucket name will be <bucket_prefix>-<aws_region>-<random_suffix>."
  type        = string
  default     = "aws-infrastructure-core-tfstate"
}

variable "bucket_name_override" {
  description = "Optional override for the name of the S3 bucket to be created for storing terraform state files. If provided, this value will be used as the bucket name instead of the generated name using bucket_prefix and aws_region."
  type        = string
  default     = ""
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name used for Terraform state locking"
  type        = string
  default     = "aws-infrastructure-core-tf-locks"
}

variable "nonconcurrent_version_expiration_days" {
  description = "Number of days after which non-concurrent versions of the Terraform state file will be automatically deleted from the S3 bucket."
  type        = number
  default     = 90
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the state bucket even if it contains objects. Keep false by default."
  type        = bool
  default     = false
}

variable "enable_tls_only_policy" {
  description = "Attach bucket policy denying insecure transport."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags merged with the standard tag set."
  type        = map(string)
  default     = {}
}

variable "kms_key_deletion_window_in_days" {
  description = "Waiting period before the state bucket KMS key is deleted after scheduling deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.kms_key_deletion_window_in_days >= 7 && var.kms_key_deletion_window_in_days <= 30
    error_message = "kms_key_deletion_window_in_days must be between 7 and 30."
  }
}
