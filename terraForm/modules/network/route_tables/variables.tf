variable "vpc_id" {}

variable "igw_id" {}

variable "cidr_block" {
  description = "the vpc cidr block"
}

variable "Public_Subnet_id_list" {
  type = "list"
}

variable "Private_Subnet_id_list" {
  type = "list"
}