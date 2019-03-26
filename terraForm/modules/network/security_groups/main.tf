resource "aws_security_group" "ssh_in_out" {
  vpc_id = "${var.vpc_id}"
  name = "aiops-ssh_in_out"
}

resource "aws_security_group" "flask_in_out" {
  vpc_id = "${var.vpc_id}"
  name = "aiops-flask_in_out"
}

resource "aws_security_group" "eks_cluster_in_out" {
  vpc_id = "${var.vpc_id}"
  name = "aiops-eks_cluster"
  description = "Cluster communication with worker nodes"
  tags = {
    Name = "aiops-eks-demo"
  }
}

resource "aws_security_group_rule" "ssh_in" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${local.ipAddress}"]
  security_group_id = "${aws_security_group.ssh_in_out.id}"
}

resource "aws_security_group_rule" "ssh_out" {
  type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ssh_in_out.id}"
}

resource "aws_security_group_rule" "flask_in" {
  type = "ingress"
  from_port = 5000
  to_port = 5000
  protocol = "-1"
  security_group_id = "${aws_security_group.flask_in_out.id}"
  source_security_group_id = "${aws_security_group.flask_in_out.id}"
}

resource "aws_security_group_rule" "flask_out" {
  type = "egress"
  from_port = 5000
  to_port = 5000
  protocol = "-1"
  security_group_id = "${aws_security_group.flask_in_out.id}"
  source_security_group_id = "${aws_security_group.flask_in_out.id}"
}

resource "aws_security_group_rule" "eks_cluster_in" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["${local.ipAddress}"]
  security_group_id = "${aws_security_group.eks_cluster_in_out.id}"
}

resource "aws_security_group_rule" "eks_cluster_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.eks_cluster_in_out.id}"
}
