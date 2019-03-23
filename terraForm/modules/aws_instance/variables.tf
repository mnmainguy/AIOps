variable "key_name" {
  description = "the ssh key name"
}

variable "Public_Security_Group_id_list" {
  type = "list"
}

variable "Public_Subnet_id_list" {
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