resource "aws_lb_target_group" "task11-ALB" {
  name     = "task11-ALB"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_lb" "task11-LB" {
  name               = "task11-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.task11-SG.id}"]
  subnets            = ["${aws_subnet.task11-subnet-use2a.id}", "${aws_subnet.task11-subnet-use2b.id}"]

  enable_deletion_protection = true

  tags = {
    Environment = "test"
  }
}