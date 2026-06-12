data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_iam_policy_document" "operations_instance_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_security_group" "operations_instance" {
  count = var.create_operations_instance ? 1 : 0

  name        = "${local.name_prefix}-operations-sg"
  description = "Security group for the production operations instance"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-operations-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "operations_instance_https" {
  count = var.create_operations_instance ? 1 : 0

  security_group_id = aws_security_group.operations_instance[0].id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  description       = "Allow outbound HTTPS (SSM, package repos)"
}

resource "aws_iam_role" "operations_instance" {
  count = var.create_operations_instance ? 1 : 0

  name               = "${local.name_prefix}-operations-instance-role"
  assume_role_policy = data.aws_iam_policy_document.operations_instance_assume_role.json

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-operations-instance-role"
  })
}

resource "aws_iam_role_policy_attachment" "operations_instance_ssm_core" {
  count = var.create_operations_instance ? 1 : 0

  role       = aws_iam_role.operations_instance[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "operations_instance" {
  count = var.create_operations_instance ? 1 : 0

  name = "${local.name_prefix}-operations-instance-profile"
  role = aws_iam_role.operations_instance[0].name
}

resource "aws_instance" "operations" {
  count = var.create_operations_instance ? 1 : 0

  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.operations_instance_type
  subnet_id                   = module.vpc.private_subnet_ids[var.availability_zones[var.operations_private_subnet_index]]
  vpc_security_group_ids      = [aws_security_group.operations_instance[0].id]
  iam_instance_profile        = aws_iam_instance_profile.operations_instance[0].name
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.operations_root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-operations"
    Role = "operations"
  })

  depends_on = [
    aws_iam_role_policy_attachment.operations_instance_ssm_core
  ]
}
