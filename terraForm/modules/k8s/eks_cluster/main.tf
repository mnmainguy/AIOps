resource "aws_eks_cluster" "eks_cluser_prod" {
  name            = "${var.cluster_name}"
  role_arn        = "${var.eks_cluser_role_arn}"

  vpc_config {
    security_group_ids = ["${var.EKS_Cluster_Security_Group}"]
    subnet_ids         = ["${var.Public_PROD_Subnet_id_list}"]
  }

}