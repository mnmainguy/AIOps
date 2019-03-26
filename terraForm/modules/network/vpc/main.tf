resource "aws_vpc" "aiops-vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
  tags {
    Name = "aiops-eks-node"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}