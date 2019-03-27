locals {
  env="${terraform.workspace}"
  aws_az_count = {
    "default" = 2
    "DEV" = 2
    "QA" = 3
    "PROD" = 3 
  
  }
  public_subnet_range = {
    "default" = 0
    "DEV" = 0
    "QA" =  2
    "PROD" = 4 
  
  }

  private_subnet_range = {
    "default" = 1
    "DEV" = 1
    "QA" = 3
    "PROD" = 5 
  
  }
  aws_availability_zone_count = "${lookup(local.aws_az_count,env)}"
}

variable "aiops_env" {
    description = "AWS environment"
}

variable "aws_availability_zone_names" {
    description = "AWS environment"
}

variable "aws_public_subnet_range" {
    description = "AWS environment"
}

variable "region" {
    description = "AWS region"
    default = "us-west-2"
}

variable "access_key" {
    description = "AWS access key"
}
variable "secret_key" {
    description = "AWS secret key"
}
variable "vpc_cidr_block" {
    description = "AWS VPC CIDR Block to use"
    default = "10.0.0.0/16"
}
variable "ssh_key_name" {
    description = "AWS SSSH Key Name for EC2"
}

variable "ssh_public_key" {
  description = "the ssh key value"
}

variable "aws_availability_zone_count" {
    description = "Number of AWS availability zones to use"
    default = 3
}
variable "aws_env_type_count" {
    description = "Number of environment types to use - currently 3 - DEV/QA/PROD"
    default = 3
}

variable "aws_public_subnet_count" {
    description = "Number of public subnets created - aws_availability_zone_count X aws_env_type_count"
    default = 9
}

variable "aws_private_subnet_count" {
    description = "Number of private subnets created - aws_availability_zone_count X aws_env_type_count"
    default = 9
}

data "aws_subnet_ids" "Public_Subnet_id_list" {
  vpc_id = "${module.vpc_network.vpc_id}"
  tags = {
    Tier = "Public"
  }
  depends_on = ["module.subnets"]
}

data "aws_subnet_ids" "Public_PROD_Subnet_id_list" {
  vpc_id = "${module.vpc_network.vpc_id}"
  tags = {
    Tier = "Public"
    ENV = "PROD"
  }
  depends_on = ["module.subnets"]
}

variable "aws_cluster_name" {
  default = "aiops-eks-v1"
  type    = "string"
}

variable "aws_eks_cluser_arn" {
  type    = "string"
}

variable "aws_eks_nodes_role_name" {
  type    = "string"
}

variable "eks_worker_instance_type" {
  default = "p2.xlarge"
}


variable "eks_worker_desired_capacity" {
  default = 3
}

variable "eks_worker_min_size" {
  default = 1
}

variable "eks_worker_max_size" {
  default = 3
}

variable "aws_ebs_size" {
  default = 40
}

variable "eks_git_token" {
  type = "string"
}