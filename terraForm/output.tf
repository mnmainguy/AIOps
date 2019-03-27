output "aiops_env" {
  value = "${terraform.workspace}"
}

output "aws_availability_zone_count" {
  value = "${lookup(local.aws_az_count,env)}"
}

output "aws_subnet_range" {
  value = "${lookup(local.subnet_range,env)}"
}

data "aws_availability_zones" "available" {}

output "aws_availability_zone_names" {
  value = "${data.aws_availability_zones.available.names}"
}

output "config_map_aws_auth" {
  value = "${module.eks_cluster.config_map_aws_auth}"
}
output "kubeconfig" {
    value = "${module.eks_cluster.kubeconfig}"
}


