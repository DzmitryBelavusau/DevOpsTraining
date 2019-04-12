provider "aws" {
  region     = "us-east-2"
}

/*resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "task11-gw" {
  vpc_id = "vpc-ce2435a6"

  tags = {
    Name = "task11-main-gw"
  }
}

resource "aws_subnet" "task11-subnet-use2a" {
  vpc_id            = "vpc-ce2435a6"
  cidr_block        = "172.31.0.0/20"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "false"
}

resource "aws_subnet" "task11-subnet-use2b" {
  vpc_id            = "vpc-ce2435a6"
  cidr_block        = "172.31.16.0/20"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "false"
}*/

data "aws_subnet" "use2a" {
  filter {
    name   = "availability-zone"
    values = ["us-east-2a"]
  }
}

data "aws_subnet" "use2b" {
  filter {
    name   = "availability-zone"
    values = ["us-east-2b"]
  }
}