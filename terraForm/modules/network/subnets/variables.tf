data "aws_availability_zones" "available" {}

variable "vpc_id" {
  description = "the vpc networks id"
}

variable "availability_zone_count" {
  description = "Count of current availability zones in us west-2"
}

variable "cluster_name" {
}