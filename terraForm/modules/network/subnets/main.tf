data "aws_availability_zones" "available" {}

resource "aws_subnet" "public-prod" {
  count = 1
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet PROD-${count.index}"
  }
}

resource "aws_subnet" "private-prod" {
  count = 1
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.1${count.index}.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Private Subnet PROD-${count.index}"
  }
}

resource "aws_subnet" "public-qa" {
  count = 1
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.2${count.index}.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet QA-${count.index}"
  }
}

resource "aws_subnet" "private-qa" {
  count = 1
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.3${count.index}.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Private Subnet QA-${count.index}"
  }
}

resource "aws_subnet" "public-dev" {
  count = 1
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.4${count.index}.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet DEV-${count.index}"
  }
}

resource "aws_subnet" "private-dev" {
  count = 1
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.5${count.index}.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Private Subnet DEV-${count.index}"
  }
}