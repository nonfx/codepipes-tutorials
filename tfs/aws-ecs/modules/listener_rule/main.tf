

resource "aws_lb_listener_rule" "lb-listener-rule" {
  count = (length(coalesce(var.path, [])) > 0 && length(coalesce(var.site, [])) > 0) ? 1 : 0
  listener_arn = var.lb_listener_arn
  priority     = 100 + var.number

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = var.path
    }
  }
  condition {
    host_header {
      values = var.site
    }
  }
}
