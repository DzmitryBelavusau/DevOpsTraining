resource "aws_security_group" "task11-SG-instance" {
  name        = "task11-SG-instance"
  description = "allow all ssh, alb 80"
  vpc_id      = "vpc-ce2435a6"

 ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.task11-SG-alb.id}"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.task11-SG-alb.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "task11-SG-alb" {
  name        = "task11-SG-alb"
  description = "allow all 80"
  vpc_id      = "vpc-ce2435a6"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}