output "aws_autoscaling_group_id" {
  value = "${aws_autoscaling_group.eks_worker_autoscaling.id}"
}