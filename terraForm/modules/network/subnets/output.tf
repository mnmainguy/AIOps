output "public_prod_subnet_ids" {
  value = ["${aws_subnet.public-prod.*.id}"]
}

output "private_prod_subnet_ids" {
  value = ["${aws_subnet.private-prod.*.id}"]
}

output "public_qa_subnet_ids" {
  value = ["${aws_subnet.public-qa.*.id}"]
}
output "private_qa_subnet_ids" {
  value = ["${aws_subnet.private-qa.*.id}"]
}

output "public_dev_subnet_ids" {
  value = ["${aws_subnet.public-dev.*.id}"]
}
output "private_dev_subnet_ids" {
  value = ["${aws_subnet.private-dev.*.id}"]
}