output "aws_eks_id" {
  value = "${aws_eks_cluster.eks_prod.id}"
}