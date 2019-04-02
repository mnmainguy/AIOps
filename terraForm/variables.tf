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