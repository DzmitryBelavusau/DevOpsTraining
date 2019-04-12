resource "aws_lb_target_group" "task11-ALB" {
  name     = "task11-ALB"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-ce2435a6"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_lb_target_group.task11-ALB.arn}"
  target_id        = "${data.aws_instance.task11-instID.id}"
  port             = 80
}

resource "aws_lb" "task11-LB" {
  name               = "task11-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.task11-SG-alb.id}"]
  subnets            = ["${data.aws_subnet.use2a.id}", "${data.aws_subnet.use2b.id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_listener" "task11-listener" {
  load_balancer_arn = "${aws_lb.task11-LB.arn}"
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.task11-ALB.arn}"
  }
}