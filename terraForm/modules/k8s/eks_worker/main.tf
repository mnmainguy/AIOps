resource "aws_iam_instance_profile" "aiops_eks_node" {
  name = "aiops_eks_node-${var.aiops_env}"
  role = "${var.eks_nodes_role_name}"
}

resource "aws_launch_configuration" "eks_node_launch" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.aiops_eks_node.name}"
  image_id                    = "${data.aws_ami.eks_worker.id}"
  instance_type               = "${var.eks_worker_instance_type}"
  name_prefix                 = "eks_prod_worker"
  security_groups             = ["${var.EKS_Node_Security_Group}"]
  key_name                    = "${var.key_name}"	
  user_data_base64            = "${base64encode(var.eks_node_userdata)}"

  lifecycle {
    create_before_destroy = true
  }
  depends_on = ["aws_iam_instance_profile.aiops_eks_node"]
}

resource "aws_autoscaling_group" "eks_worker_autoscaling" {
  desired_capacity     =  "${var.eks_worker_desired_capacity}"
  launch_configuration = "${aws_launch_configuration.eks_node_launch.id}"
  max_size             = "${var.eks_worker_max_size}"
  min_size             = "${var.eks_worker_min_size}"
  name                 = "eks_worker_autoscaling-${var.aiops_env}"
  vpc_zone_identifier  = ["${var.Public_Subnet_id_list}"]

  tag {
    key                 = "Name"
    value               = "eks_worker_autoscaling-${var.aiops_env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}