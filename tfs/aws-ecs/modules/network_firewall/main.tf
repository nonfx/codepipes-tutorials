locals {
  extract_resource_name = "${var.common_name_prefix}-${var.environment}-${var.number}"
}

resource "aws_networkfirewall_firewall_policy" "firewall-policy" {
  name = "firewall-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.inbound-firewall-rule-group.arn
    }
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-firewall-policy")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

resource "aws_networkfirewall_rule_group" "inbound-firewall-rule-group" {
  capacity = 100
  name     = "inbound-firewall-rule-group"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["TLS_SNI"]
        targets              = [".example.com"]
      }
    }
  }

  lifecycle {
    ignore_changes = [rule_group]
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-firewall-rule-group")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_networkfirewall_firewall" "firewall" {
  name                = "firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.firewall-policy.arn
  vpc_id              = var.vpc-id

  subnet_mapping {
    subnet_id = var.subnet-firewall-a-id
  }

  subnet_mapping {
    subnet_id = var.subnet-firewall-b-id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-firewall")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

resource "aws_networkfirewall_logging_configuration" "firewall-logging-configuration" {
  firewall_arn = aws_networkfirewall_firewall.firewall.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.firewall-cloudwatch-log-group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
  }
}

resource "aws_cloudwatch_log_group" "firewall-cloudwatch-log-group" {
  name              = "/network-firewall/${local.extract_resource_name}"
  retention_in_days = 365

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-firewall-log-group")
    },
    {
      environment = var.environment
    },
    var.tags,
  )


}
