resource "aws_instance" "example" {
  count = "${length(var.Public_Subnet_id_list)}"
  subnet_id = "${var.Public_Subnet_id_list[count.index]}"
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"	
  vpc_security_group_ids = ["${var.Public_Security_Group_id_list}"]
}