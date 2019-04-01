locals {
  env="${terraform.workspace}"
  aws_az_count = {
    "default" = 2
    "TOOLS" = 2
    "TRAIN" = 3
    "PROD" = 4 
  
  }
  public_subnet_range = {
    "default" = 0
    "TOOLS" = 0
    "TRAIN" =  2
    "PROD" = 4 
  
  }

  private_subnet_range = {
    "default" = 1
    "TOOLS" = 1
    "TRAIN" = 3
    "PROD" = 5 
  }

 cluster_name = {
    "default" = "kubeflow"
    "TOOLS" = "kubeflow"
    "TRAIN" = "mnist_train"
    "PROD" = "mnist_prod" 
  }
  worker_desired_capacity = {
    "default" = 1
    "TOOLS" = 1
    "TRAIN" = 2
    "PROD" = 2
  }

  worker_min_size = {
    "default" = 1
    "TOOLS" = 1
    "TRAIN" = 3
    "PROD" = 3
  }
  
  worker_max_size = {
    "default" = 3
    "TOOLS" = 3
    "TRAIN" = 4
    "PROD" = 4
  }
  aws_availability_zone_count="${lookup(local.aws_az_count,env)}"
  aws_public_subnet_range="${lookup(local.public_subnet_range,env)}"
  aws_private_subnet_range="${lookup(local.private_subnet_range,env)}"
  aws_cluster_name="${lookup(local.cluster_name,env)}"
  eks_worker_desired_capacity="${lookup(local.worker_desired_capacity,env)}"
  eks_worker_min_size="${lookup(local.worker_min_size,env)}"
  eks_worker_max_size="${lookup(local.worker_max_size,env)}"
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

variable "aws_eks_cluser_arn" {
  type    = "string"
}

variable "aws_eks_nodes_role_name" {
  type    = "string"
}

variable "eks_worker_instance_type" {
  default = "p2.xlarge"
}

variable "aws_ebs_size" {
  default = 40
}

variable "eks_git_token" {
  type = "string"
}