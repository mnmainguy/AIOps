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


