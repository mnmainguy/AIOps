
variable "vpc_id" {
  description = "the vpc networks id"
}

variable "cluster_name" {
}

data "http" "ip-address" {
  url = "http://ipv4.icanhazip.com"
}

locals  {
  ipAddress = "${chomp(data.http.ip-address.body)}/32"
}