module "vpc" {
  source = "../../modules/vpc"

  name        = var.project_name
  environment = var.environment

  vpc_cidr                    = var.vpc_cidr
  availability_zones          = var.availability_zones
  public_subnet_cidrs         = var.public_subnet_cidrs
  private_subnet_cidrs        = var.private_subnet_cidrs
  enable_nat_gateway          = var.enable_nat_gateway
  single_nat_gateway          = var.single_nat_gateway
  flow_logs_retention_in_days = var.flow_logs_retention_in_days
  enable_flow_logs_kms        = true
  tags                        = local.common_tags
}
