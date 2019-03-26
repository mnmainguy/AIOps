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
    default = 4
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
  default = "aiops-eks"
  type    = "string"
}

variable "aws_eks_role_arn" {
  type    = "string"
}