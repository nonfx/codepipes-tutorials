locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.app}"
}

resource "aws_lb_target_group" "tg" {
  name                 = substr("${var.app}${local.extract_resource_name}tg", 0, 32)
  port                 = 3000
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc-id
  deregistration_delay = 60

  health_check {
    port = 3000
    path = var.healthCheck
  }

}