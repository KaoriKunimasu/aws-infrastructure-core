data "aws_caller_identity" "current" {
}

module "vpc" {
  source = "../../modules/vpc"

  name        = local.name
  environment = local.environment
  vpc_cidr    = var.vpc_cidr

  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  flow_logs_retention_in_days = 30

  tags = local.common_tags

  public_subnet_tags = {
    Network = "public"
  }

  private_subnet_tags = {
    Network = "private"
  }
}