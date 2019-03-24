variable "vpc_id" {}

variable "key_name" {
  description = "the ssh key name"
}

variable "public_key" {
  description = "the ssh key value"
}

variable "Public_Security_Group_id_list" {
  type = "list"
}

data "aws_ami" "ubuntu" {
    most_recent = true
filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
}

filter {
    name   = "virtualization-type"
    values = ["hvm"]
}

owners = ["099720109477"] # Canonical
}

variable "Public_Subnet_id_list" {
  type = "list"
}

variable "public_subnet_count" {
    description = "Number of public subnets created - aws_availability_zone_count X aws_env_type_count"
}