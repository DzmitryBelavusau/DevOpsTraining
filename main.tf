provider "aws" {
  region     = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "task11-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "task11-main-gw"
  }
}

resource "aws_subnet" "task11-subnet-use2a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.31.0.0/20"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "false"
}

resource "aws_subnet" "task11-subnet-use2b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.31.16.0/20"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "false"
}
