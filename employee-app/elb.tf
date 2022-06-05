resource "aws_lb" "employee_app_lb" {
  load_balancer_type = "application"
  name               = "app-elb"
  security_groups = [
    aws_security_group.lb_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

resource "aws_lb_target_group" "employee_app_lb_tg" {
  name        = "app-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    interval            = 40
    matcher             = "200"
    path                = "/"
    timeout             = 30
    unhealthy_threshold = 5
  }

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
}

resource "aws_lb_listener" "employee_app_listener" {
  load_balancer_arn = aws_lb.employee_app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.employee_app_lb_tg.arn
    type             = "forward"
  }
}