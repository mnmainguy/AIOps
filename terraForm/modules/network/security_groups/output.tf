output "sg-ssh_id" {
  value = "${aws_security_group.ssh_in_out.id}"
} #makes security groups build before webservers

output "flask_in_out" {
  value = "${aws_security_group.flask_in_out.id}"
} #makes security groups build before webservers

output "eks_cluster_in_out" {
  value = "${aws_security_group.eks_cluster_in_out.id}"
} #makes security groups build before webservers

output "public_security_groups" {
  value = ["${aws_security_group.ssh_in_out.id}","${aws_security_group.flask_in_out.id}","${aws_security_group.eks_cluster_in_out.id}"]
}