locals {
  env="${terraform.workspace}"
  aws_az_count = {
    "default" = 2
    "TOOLS" = 2
    "TRAIN" = 3
    "PROD" = 4 
  
  }
  public_subnet_range = {
    "default" = 1
    "TOOLS" = 1
    "TRAIN" = 3
    "PROD" = 5 
  
  }

  private_subnet_range = {
    "default" = 2
    "TOOLS" = 2
    "TRAIN" = 4
    "PROD" = 6 
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

}
output "env" {
  value = "${local.env}"
}

output "aws_availability_zone_count" {
  value = "${lookup(local.aws_az_count,local.env)}"
}
output "aws_public_subnet_range" {
  value = "${lookup(local.public_subnet_range,local.env)}"
}
output "aws_private_subnet_range" {
  value = "${lookup(local.private_subnet_range,local.env)}"
}
output "aws_cluster_name" {
  value = "${lookup(local.cluster_name,local.env)}"
}
output "eks_worker_desired_capacity" {
  value = "${lookup(local.worker_desired_capacity,local.env)}"
}
output "eks_worker_min_size" {
  value = "${lookup(local.worker_min_size,local.env)}"
}
output "eks_worker_max_size" {
  value = "${lookup(local.worker_max_size,local.env)}"
}
