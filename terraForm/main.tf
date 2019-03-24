provider "http" {
  version = "~> 1.0"
}

provider "aws" {
  region = "${var.region}"
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
  availability_zone_count = "${var.aws_availability_zone_count}"
}

module "route_tables" {
  source = "./modules/network/route_tables/"
  vpc_id = "${module.vpc_network.vpc_id}"
  igw_id = "${module.internet_gateway.igw_id}"
  cidr_block = "${var.vpc_cidr_block}"
  public_subnet_count = "${var.aws_public_subnet_count}"
}

module "aws_instance" {
  source = "./modules/aws_instance/"
  Public_Security_Group_id_list = ["${module.security_groups.public_security_groups}"]
  key_name = "${var.ssh_key_name}"
  vpc_id = "${module.vpc_network.vpc_id}"
  public_subnet_count = "${var.aws_public_subnet_count}"
}
