locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    ManagedBy   = "terraform"
    CostCenter  = var.cost_center
    Environment = var.environment
    Owner       = var.owner
  }
}