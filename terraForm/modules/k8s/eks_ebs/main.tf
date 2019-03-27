resource "aws_ebs_volume" "EKS_lb" {
  availability_zone = "${var.Public_PROD_Subnet_id_list}"
  size              = "${var.EBSsize}"

  tags = {
    Name = "EKS_lb"
  }
}