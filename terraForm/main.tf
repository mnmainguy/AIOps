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
  cluster_name = "${var.aws_cluster_name}"
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

module "eks_cluster" {
  source = "./modules/k8s/eks_cluster/"
  cluster_name = "${var.aws_cluster_name}"
  eks_cluser_role_arn = "${var.aws_eks_cluser_arn}"
  eks_nodes_role_name = "${var.aws_eks_nodes_role_name}"
  EKS_Cluster_Security_Group = ["${module.security_groups.eks_cluser_security_groups}"]
  Public_PROD_Subnet_id_list = "${data.aws_subnet_ids.Public_PROD_Subnet_id_list.ids}"
}

module "eks_worker" {
  source = "./modules/k8s/eks_worker"
  cluster_name = "${var.aws_cluster_name}"
  aws_eks_version = "${module.eks_cluster.aws_eks_version}"
  eks_node_userdata = "${module.eks_cluster.eks_node_userdata}"
  EKS_Node_Security_Group = ["${module.security_groups.eks_node_security_groups}"]
  eks_nodes_role_name = "${var.aws_eks_nodes_role_name}"
  Public_PROD_Subnet_id_list = "${data.aws_subnet_ids.Public_PROD_Subnet_id_list.ids}"
  eks_worker_instance_type = "${var.eks_worker_instance_type}"
  eks_worker_desired_capacity = "${var.eks_worker_desired_capacity}"
  eks_worker_max_size = "${var.eks_worker_max_size}"
  eks_worker_min_size = "${var.eks_worker_min_size}"
}

module "eks_ebs" {
  source = "./modules/k8s/eks_ebs"
  Public_PROD_Subnet_id_list = "${data.aws_subnet_ids.Public_PROD_Subnet_id_list.ids}"
  EBSsize = "${var.aws_ebs_size}"
}
