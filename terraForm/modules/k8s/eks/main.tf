resource "aws_eks_cluster" "eks_prod" {
  name            = "${var.cluster_name}"
  role_arn        = "${var.role_arn}"

  vpc_config {
    security_group_ids = ["${var.Public_Security_Group_id_list}"]
    subnet_ids         = ["${var.Public_PROD_Subnet_id_list}"]
  }

}