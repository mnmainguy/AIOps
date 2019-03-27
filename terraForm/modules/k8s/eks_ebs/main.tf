resource "aws_ebs_volume" "EKS_lb" {
  count = "${var.availability_zone_count}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  size              = "${var.EBSsize}"

  tags = {
    Name = "EKS_lb"
  }
}