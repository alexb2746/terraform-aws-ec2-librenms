terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.latest_ubuntu_22_04.id
  instance_type          = var.instance_size
  vpc_security_group_ids = [aws_security_group.allow_inbound_all_outbound.id]
  key_name               = var.key
  subnet_id              = data.aws_subnet.subnet_us_west_2.id
  user_data              = var.install_librenms ? file("${path.module}/scripts/librenms_install.sh") : null

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name    = var.name
    Service = "removed"
    Team    = "removed"
  }
}

resource "aws_security_group" "allow_inbound_all_outbound" {
  name   = "ubuntu security group"
  vpc_id = data.aws_vpc.vpc_us_west_2.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
  }

  dynamic "ingress" {
    for_each = toset(var.tcp_allowed_ports_in)
    content {
      description = "internal traffic"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }

   dynamic "ingress" {
    for_each = toset(var.udp_allowed_ports_in)
    content {
      description = "internal traffic"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = var.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##### currently working on this ####
# resource "aws_ebs_snapshot" "monthly_snapshot" {
#   count       = 1
#   volume_id   = module.ubuntu.volume_id
#   description = "Monthly snapshot for ${module.ubuntu.instance_name}"
#   tags = {
#     Name = "Monthly Snapshot"
#   }
# }

# resource "aws_cloudwatch_event_rule" "monthly_snapshot_trigger" {
#   name        = "MonthlySnapshotTrigger"
#   description = "Trigger to create monthly snapshot"
#   schedule_expression = "cron(0 0 1 * ? *)"
# }

# resource "aws_cloudwatch_event_target" "monthly_snapshot_target" {
#   rule      = aws_cloudwatch_event_rule.monthly_snapshot_trigger.name
#   target_id = aws_ebs_snapshot.monthly_snapshot[0].id
#   arn       = aws_ebs_snapshot.monthly_snapshot[0].arn
# }