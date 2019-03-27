variable "Public_PROD_Subnet_id_list" {
  type = "list"
}

variable "EBSsize" {
  type = "string"
}

data "aws_availability_zones" "available" {}

variable "availability_zone_count" {
  description = "Count of current availability zones in us west-2"
}