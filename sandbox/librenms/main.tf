terraform {
  backend "s3" {
    bucket         = "terraform-removed"
    key            = "librenms/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-removed"
    encrypt        = true
  }
}

locals {
  profile = "removed"
}

provider "aws" {
  profile = local.profile
  region  = "us-west-2"
}

module "ubuntu" {
  source        = "../../modules/ubuntu"
  profile       = local.profile
  key           = "removed"
  name          = "librenms"
  instance_size = "t2.medium"

  volume_size = 30
  # only set this to true to run this for new instances; otherwise set it to false
  install_librenms = true
}

output "ubuntu_private_ip" {
  value       = module.ubuntu.private_ip
  description = "output the private ip of the server"
}

