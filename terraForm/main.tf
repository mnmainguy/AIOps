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
  cluster_name = "${var.aws_cluster_name}"
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
  cluster_name = "${var.aws_cluster_name}"
}

module "route_tables" {
  source = "./modules/network/route_tables/"
  vpc_id = "${module.vpc_network.vpc_id}"
  igw_id = "${module.internet_gateway.igw_id}"
  cidr_block = "${var.vpc_cidr_block}"
  public_subnet_count = "${var.aws_public_subnet_count}"
  Public_Subnet_id_list = "${data.aws_subnet_ids.Public_Subnet_id_list.ids}"
}

# module "aws_instance" {
#   source = "./modules/aws_instance/"
#   Public_Security_Group_id_list = ["${module.security_groups.public_security_groups}"]
#   key_name = "${var.ssh_key_name}"
#   public_key = "${var.ssh_public_key}"
#   vpc_id = "${module.vpc_network.vpc_id}"
#   public_subnet_count = "${var.aws_public_subnet_count}"
#   Public_Subnet_id_list = "${data.aws_subnet_ids.Public_Subnet_id_list.ids}"
# }

module "eks" {
  source = "./modules/k8s/eks/"
  cluster_name = "${var.aws_cluster_name}"
  role_arn = "${var.aws_eks_role_arn}"
  Public_Security_Group_id_list = ["${module.security_groups.public_security_groups}"]
  Public_PROD_Subnet_id_list = "${data.aws_subnet_ids.Public_PROD_Subnet_id_list.ids}"

}
