resource "aws_internet_gateway" "aiops-igw" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "aiops-igw"
  }
}