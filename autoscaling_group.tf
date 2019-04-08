resource "aws_launch_configuration" "task11-LC" {
  name_prefix     = "task11-"
  image_id        = "ami-0c55b159cbfafe1f0"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.task11-SG.id}"]
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "task11-ASG" {
  name                      = "task11-ASG"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.task11-LC.name}"
  vpc_zone_identifier       = ["${aws_subnet.task11-subnet-use2a.id}", "${aws_subnet.task11-subnet-use2b.id}"]

  lifecycle {
    create_before_destroy = true
  }
}