terraform {
  backend "s3" {
    bucket         = "terraform-removed"
    profile        = "removed"
    key            = "librenms/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "#removed"
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
  key           = "removed-key"
  name          = "librenms"
  instance_size = "t2.xlarge"
  volume_size   = 250
  # only set this to true to run this for new instances; otherwise set it to false
  install_librenms = false
}

output "ubuntu_private_ip" {
  value       = module.ubuntu.private_ip
  description = "output the private ip of the server"
}