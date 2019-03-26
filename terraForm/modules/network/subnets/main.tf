resource "aws_subnet" "public-prod" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet PROD-${count.index}"
    Tier = "Public"
    ENV = "PROD"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private-prod" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.1${count.index}.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Private Subnet PROD-${count.index}"
    Tier = "Private"
    ENV = "PROD"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public-qa" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.2${count.index}.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet QA-${count.index}"
    Tier = "Public"
    ENV = "QA"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private-qa" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.3${count.index}.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Private Subnet QA-${count.index}"
    Tier = "Private"
    ENV = "QA"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public-dev" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.4${count.index}.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet DEV-${count.index}"
    Tier = "Public"
    ENV = "DEV"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private-dev" {
  count = "${var.availability_zone_count}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.5${count.index}.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Private Subnet DEV-${count.index}"
    Tier = "Private"
    ENV = "DEV"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}