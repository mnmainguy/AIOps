output "aws_eks_nodes_role_name" {
  value = "${aws_iam_role.aiops_eks_nodes.name}"
}
output "eks_cluser_role_arn" {
  value = "${aws_iam_role.aiops_eks_cluster.arn}"
}