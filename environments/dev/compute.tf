data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "dev_instance" {
  name        = "${local.name_prefix}-instance-sg"
  description = "Security group for dev validation instances"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance-sg"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "dev_instance_https" {
  security_group_id = aws_security_group.dev_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "Allow outbound HTTPS (SSM, package repos)"
}


data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid    = "AllowEC2AssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "dev_instance" {
  name               = "${local.name_prefix}-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.dev_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "dev_instance" {
  name = "${local.name_prefix}-instance-profile"
  role = aws_iam_role.dev_instance.name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance-profile"
    }
  )
}

resource "aws_instance" "dev_validation" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnet_ids[var.availability_zones[0]]
  vpc_security_group_ids      = [aws_security_group.dev_instance.id]
  iam_instance_profile        = aws_iam_instance_profile.dev_instance.name
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.instance_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data_replace_on_change = true
  user_data                   = <<-EOT
    #!/bin/bash
    echo "dev environment instance" > /etc/motd
  EOT

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-validation"
      Role = "validation"
    }
  )
}