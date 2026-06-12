resource "aws_security_group" "vpc_endpoints" {
  count = var.enable_ssm_endpoints ? 1 : 0

  name        = "${local.name_prefix}-vpce-sg"
  description = "Allow HTTPS from within the VPC to interface endpoints"
  vpc_id      = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpce-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoints_https" {
  count = var.enable_ssm_endpoints ? 1 : 0

  security_group_id = aws_security_group.vpc_endpoints[0].id
  cidr_ipv4         = aws_vpc.this.cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "HTTPS from within the VPC"
}

resource "aws_vpc_endpoint" "ssm" {
  for_each = var.enable_ssm_endpoints ? toset(local.ssm_interface_endpoints) : []

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = [for subnet in aws_subnet.private : subnet.id]
  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpce-${each.value}"
      Type = "vpc-endpoint"
    }
  )
}
