resource "aws_lb_listener" "lb-http-listener" {
  load_balancer_arn = var.aws_lb_arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb-https-listener" {
  load_balancer_arn = var.aws_lb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.lb-listener-certificate-arn

  default_action {
    type             = "forward"
    target_group_arn = var.default_target_group
  }
}