output "public_ip" {
  value = "${aws_instance.example.*.id}"
}