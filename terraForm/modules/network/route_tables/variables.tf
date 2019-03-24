variable "vpc_id" {}

variable "igw_id" {}

variable "cidr_block" {
  description = "the vpc cidr block"
}

variable "Public_Subnet_id_list" {
  type = "list"
}

variable "public_subnet_count" {
    description = "Number of public subnets created - aws_availability_zone_count X aws_env_type_count"
}