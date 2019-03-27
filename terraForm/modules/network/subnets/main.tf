resource "aws_subnet" "public-${var.aiops_env}" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.aws_availability_zone_names[count.index]}"
  cidr_block = "10.0.${var.subnet_range}${count.index}.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet ${var.aiops_env}-${count.index}"
    Tier = "Public"
    ENV = "${var.aiops_env}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private-${var.aiops_env}" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${var.aws_availability_zone_names[count.index]}"
  cidr_block = "10.0.1${count.index}.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Private Subnet ${var.aiops_env}-${count.index}"
    Tier = "Private"
    ENV = "${var.aiops_env}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}