provider "aws" {
  region     = "us-east-2"
}

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

data "aws_instance" "task11-instID" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["task11-ASG"]
  }
}