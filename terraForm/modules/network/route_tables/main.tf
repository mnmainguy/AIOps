resource "aws_route_table" "public-rt" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw_id}"
  }
  tags {
    Name = "aiops-public-rt"
  }
}

resource "aws_route_table_association" "public-rt" {
  count = "${var.public_subnet_count}"
  subnet_id = "${var.Public_Subnet_id_list[count.index]}"
  route_table_id = "${aws_route_table.public-rt.id}"
}