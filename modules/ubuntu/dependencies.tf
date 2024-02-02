data "aws_ami" "latest_ubuntu_22_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_vpc" "vpc_us_west_2" {
  filter {
    name   = "tag:Name"
    values = ["vpc-usw2"]
  }
}

data "aws_subnet" "subnet_us_west_2" {
  vpc_id = data.aws_vpc.vpc_us_west_2.id

  filter {
    name   = "availability-zone"
    values = ["us-west-2${var.az}"]
  }
}