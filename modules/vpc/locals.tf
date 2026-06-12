locals {
  name_prefix = "${var.name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Module      = "vpc"
    }
  )

  public_subnets = {
    for index, az in var.availability_zones :
    az => {
      az   = az
      cidr = var.public_subnet_cidrs[index]
    }
  }

  private_subnets = {
    for index, az in var.availability_zones :
    az => {
      az   = az
      cidr = var.private_subnet_cidrs[index]
    }
  }

  public_subnet_keys = sort(keys(local.public_subnets))

  single_nat_gateway_key = length(local.public_subnet_keys) > 0 ? local.public_subnet_keys[0] : null

  nat_gateway_map = var.enable_nat_gateway ? (
    var.single_nat_gateway ? {
      (local.single_nat_gateway_key) = local.public_subnets[local.single_nat_gateway_key]
    } : local.public_subnets
  ) : {}

  private_route_table_map = var.enable_nat_gateway && !var.single_nat_gateway ? {
    for az, subnet in local.private_subnets :
    az => {
      name = "${local.name_prefix}-private-${az}"
    }
    } : {
    shared = {
      name = "${local.name_prefix}-private"
    }
  }
  ssm_interface_endpoints = [
    "ssm",
    "ssmmessages",
    "ec2messages",
  ]

}
