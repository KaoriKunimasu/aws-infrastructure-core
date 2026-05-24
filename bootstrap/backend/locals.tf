data "aws_caller_identity" "current" {}

locals {
  default_tags = {
    Project     = "core-infrastructure"
    ManagedBy   = "Terraform"
    CostCenter  = "platform-engineering"
    Environment = "shared"
    repository  = "aws-infrastructure-core"
  }

  common_tags = merge(local.default_tags, var.tags)

  state_bucket_name = var.bucket_name_override != "" ? lower(var.bucket_name_override) : lower("${var.bucket_prefix}-${data.aws_caller_identity.current.account_id}-${random_id.bucket_suffix.hex}-${var.aws_region}")

}