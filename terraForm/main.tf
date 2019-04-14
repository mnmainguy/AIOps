provider "http" {
  version = "~> 1.0"
}

provider "aws" {
  region = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  version = "~> 2.3"
}

module "workspaces" {
  source = "./modules/workspaces/"
}

module "vpc_network" {
  source = "./modules/network/vpc/"
  cidr_block = "${var.vpc_cidr_block}"
  cluster_name = "${module.workspaces.aws_cluster_name}"
 }

module "internet_gateway" {
  source = "./modules/network/igw/"
  vpc_id = "${module.vpc_network.vpc_id}"
}

module "security_groups" {
  source = "./modules/network/security_groups/"
  vpc_id = "${module.vpc_network.vpc_id}"
  cluster_name = "${module.workspaces.aws_cluster_name}"
}

module "iam" {
  source = "./modules/iam/"
  aiops_env = "${module.workspaces.env}"
}

module "subnets" {
  source = "./modules/network/subnets/"
  vpc_id = "${module.vpc_network.vpc_id}"
  availability_zone_count = "${module.workspaces.aws_availability_zone_count}"
  public_subnet_range = "${module.workspaces.aws_public_subnet_range}"
  private_subnet_range = "${module.workspaces.aws_private_subnet_range}"
  aiops_env = "${module.workspaces.env}"
  cluster_name = "${module.workspaces.aws_cluster_name}"
}

module "route_tables" {
  source = "./modules/network/route_tables/"
  vpc_id = "${module.vpc_network.vpc_id}"
  igw_id = "${module.internet_gateway.igw_id}"
  cidr_block = "${var.vpc_cidr_block}"
  public_subnet_count = "${module.workspaces.aws_availability_zone_count}"
  Public_Subnet_id_list = "${module.subnets.public_subnet_ids}"
}

module "s3" { 
  source = "./modules/s3/"
  aiops_env = "${module.workspaces.env}"
}

module "eks_cluster" {
  source = "./modules/k8s/eks_cluster/"
  cluster_name = "${module.workspaces.aws_cluster_name}"
  eks_cluser_role_arn = "${module.iam.eks_cluser_role_arn}"
  eks_nodes_role_arn = "${module.iam.eks_nodes_role_arn}"
  EKS_Cluster_Security_Group = ["${module.security_groups.eks_cluser_security_groups}"]
  Public_Subnet_id_list = "${module.subnets.public_subnet_ids}"
  aiops_env = "${module.workspaces.env}"
}

module "eks_worker" {
  source = "./modules/k8s/eks_worker"
  cluster_name = "${module.workspaces.aws_cluster_name}"
  aws_eks_version = "${module.eks_cluster.aws_eks_version}"
  eks_node_userdata = "${module.eks_cluster.eks_node_userdata}"
  EKS_Node_Security_Group = ["${module.security_groups.eks_node_security_groups}"]
  eks_nodes_role_name = "${module.iam.aws_eks_nodes_role_name}"
  Public_Subnet_id_list = "${module.subnets.public_subnet_ids}"
  eks_worker_instance_type = "${module.workspaces.eks_worker_instance_type}"
  eks_worker_desired_capacity = "${module.workspaces.eks_worker_desired_capacity}"
  eks_worker_max_size = "${module.workspaces.eks_worker_max_size}"
  eks_worker_min_size = "${module.workspaces.eks_worker_min_size}"
  key_name = "${var.ssh_key_name}"
  aiops_env = "${module.workspaces.env}"
}

module "eks_ebs" {
  source = "./modules/k8s/eks_ebs"
  EBSsize = "${module.workspaces.aws_ebs_size}"
  availability_zone_count = "${module.workspaces.aws_availability_zone_count}"
  aiops_env = "${module.workspaces.env}"
}
