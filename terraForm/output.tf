output "config_map_aws_auth" {
  value = "${module.eks_cluster.config_map_aws_auth}"
}
output "kubeconfig" {
    value = "${module.eks_cluster.kubeconfig}"
}


