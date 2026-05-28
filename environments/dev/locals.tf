locals {
  name        = "core"
  environment = "dev"
  name_prefix = "${local.name}-${local.environment}"

  common_tags = {
    Project     = "core-infrastructure"
    ManagedBy   = "terraform"
    CostCenter  = "platform-engineering"
    Environment = local.environment
    Repository  = "aws-infrastructure-core"
  }
}