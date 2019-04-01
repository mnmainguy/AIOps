data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-gpu-node-${var.aws_eks_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

variable "aws_eks_version" {
}

variable "EKS_Node_Security_Group" {
  type = "list"
}

variable "eks_nodes_role_name" {
}

variable "eks_node_userdata" {
}

variable "cluster_name" {
}

variable "Public_Subnet_id_list" {
  type = "list"
}


variable "eks_worker_instance_type" {
}


variable "eks_worker_desired_capacity" {
}

variable "eks_worker_min_size" {
}

variable "eks_worker_max_size" {
}

variable "key_name" {
}