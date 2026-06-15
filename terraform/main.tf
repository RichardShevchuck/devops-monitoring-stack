terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}



module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_groups.web_sg_id
}


module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}


resource "local_file" "ansible_inventory" {
  content  = <<-EOT
[monitoring]
${module.ec2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
    EOT
  filename = "../ansible/inventory.ini"
}
