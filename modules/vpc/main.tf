data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )

  lifecycle {
    precondition {
      condition = (
        length(var.availability_zones) > 0 &&
        length(var.availability_zones) == length(var.public_subnet_cidrs) &&
        length(var.availability_zones) == length(var.private_subnet_cidrs)
      )
      error_message = "availability_zones, public_subnet_cidrs, and private_subnet_cidrs must all be non-empty and have the same length."
    }
  }
}

resource "aws_internet_gateway" "this" {
  count = var.enable_internet_gateway ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    local.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.name_prefix}-public-${each.key}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = merge(
    local.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.name_prefix}-private-${each.key}"
      Tier = "private"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public"
      Tier = "public"
    }
  )
}

resource "aws_route" "public_internet_access" {
  count = var.enable_internet_gateway ? 1 : 0

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_map

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = var.single_nat_gateway ? "${local.name_prefix}-nat-eip" : "${local.name_prefix}-nat-eip-${each.key}"
      Type = "nat-eip"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_map

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    local.common_tags,
    {
      Name = var.single_nat_gateway ? "${local.name_prefix}-nat" : "${local.name_prefix}-nat-${each.key}"
      Type = "nat-gateway"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  for_each = local.private_route_table_map

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = each.value.name
      Tier = "private"
    }
  )
}

resource "aws_route" "private_nat" {
  for_each = var.enable_nat_gateway ? aws_route_table.private : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[local.single_nat_gateway_key].id : aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = var.enable_nat_gateway && !var.single_nat_gateway ? aws_route_table.private[each.key].id : aws_route_table.private["shared"].id
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/${local.name_prefix}/flow-logs"
  retention_in_days = var.flow_logs_retention_in_days

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-flow-logs"
      Type = "vpc-flow-logs"
    }
  )
}

data "aws_iam_policy_document" "flow_logs_assume_role" {
  statement {
    sid    = "AllowVpcFlowLogsServiceAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vpc-flow-log/*"
      ]
    }
  }
}

resource "aws_iam_role" "flow_logs" {
  name               = "${local.name_prefix}-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-flow-logs-role"
    }
  )
}

data "aws_iam_policy_document" "flow_logs_permissions" {
  statement {
    sid    = "AllowFlowLogsWriteToCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.flow_logs.arn,
      "${aws_cloudwatch_log_group.flow_logs.arn}:*"
    ]
  }

  statement {
    sid    = "AllowFlowLogsDescribeLogGroupsAndStreams"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "flow_logs" {
  name   = "${local.name_prefix}-flow-logs-policy"
  role   = aws_iam_role.flow_logs.id
  policy = data.aws_iam_policy_document.flow_logs_permissions.json
}

resource "aws_flow_log" "this" {
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.flow_logs.arn
  iam_role_arn             = aws_iam_role.flow_logs.arn
  traffic_type             = var.flow_logs_traffic_type
  max_aggregation_interval = var.flow_logs_max_aggregation_interval
  vpc_id                   = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-flow-log"
      Type = "vpc-flow-log"
    }
  )
}
