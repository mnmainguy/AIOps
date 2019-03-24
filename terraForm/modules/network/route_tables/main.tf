resource "aws_route_table" "public-rt" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "${var.cidr_block}"
    gateway_id = "${var.igw_id}"
  }
  tags {
    Name = "aiops-public-rt"
  }
}

resource "aws_route_table_association" "public-rt" {
  count = "${var.public_subnet_count}"
  subnet_id = "${data.aws_subnet_ids.Public_Subnet_id_list.ids[count.index]}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route" "public-to-gateway" {
  route_table_id = "${aws_route_table.public-rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${var.igw_id}"
}