provider "http" {
  version = "~> 1.0"
}

provider "aws" {
  region = "us-west-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  version = "~> 2.3"
}

module "vpc_network" {
  source = "./modules/network/vpc/"
  cidr_block = "${var.vpc_cidr_block}"
 }

module "internet_gateway" {
  source = "./modules/network/igw/"
  vpc_id = "${module.vpc_network.vpc_id}"
}

module "security_groups" {
  source = "./modules/network/security_groups/"
  vpc_id = "${module.vpc_network.vpc_id}"
}

module "subnets" {
  source = "./modules/network/subnets/"
  vpc_id = "${module.vpc_network.vpc_id}"
}

module "route_tables" {
  source = "./modules/network/route_tables/"
  vpc_id = "${module.vpc_network.vpc_id}"
  igw_id = "${module.internet_gateway.igw_id}"
  Public_Subnet_id_list = ["${module.subnets.public_subnet_ids}"]
  Private_Subnet_id_list = ["${module.subnets.private_subnet_ids}"]
  cidr_block = "${var.vpc_cidr_block}"
}

module "aws_instance" {
  source = "./modules/aws_instance/"
  Public_Subnet_id_list = ["${module.subnets.public_subnet_ids}"]
  Public_Security_Group_id_list = ["${module.security_groups.public_security_groups}"]
  key_name = "${var.ssh_key_name}"
}
