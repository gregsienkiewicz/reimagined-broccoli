resource "aws_lb" "owasp" {
  name               = "owasp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_target_group" "owasp" {
  name        = "tg-owasp-lb-ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.owasp.id
  target_type = "ip"

  health_check {
    port = 3000
  }
}

resource "aws_lb_listener" "owasp" {
  load_balancer_arn = aws_lb.owasp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.owasp.arn
  }
}
