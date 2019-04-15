variable "region" {
    description = "AWS region"
    default = "us-west-2"
}

variable "access_key" {
    description = "AWS access key"
}
variable "secret_key" {
    description = "AWS secret key"
}
variable "vpc_cidr_block" {
    description = "AWS VPC CIDR Block to use"
    default = "10.0.0.0/16"
}
variable "ssh_key_name" {
    description = "AWS SSH Key Name for EC2"
}

variable "docker_login" {
    description = "Login for Dockerhub"
}

variable "docker_password" {
    description = "Passwrod for Dockerhub"
}