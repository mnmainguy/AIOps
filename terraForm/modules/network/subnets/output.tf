output "public_subnet_ids" {
  value = ["${aws_subnet.public-prod.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private-prod.*.id}"]
}
