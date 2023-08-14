locals {
  extract_resource_name = "${var.common_name_prefix}-${var.environment}-${var.number}"
}

resource "random_id" "s3_access_logs_bucket_id" {
  byte_length = 8
}

#S3 Bucket for accesslogs
resource "aws_s3_bucket" "s3_access_logs_bucket" {
  bucket = "${local.extract_resource_name}-lb-log-bucket-${random_id.s3_access_logs_bucket_id.hex}"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-lb-log-bucket")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

data "aws_elb_service_account" "main" {}


data "aws_iam_policy_document" "s3_lb_write" {
  statement {
    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.s3_access_logs_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "load_balancer_access_logs_bucket_policy" {
  bucket = aws_s3_bucket.s3_access_logs_bucket.id
  policy = data.aws_iam_policy_document.s3_lb_write.json
}



resource "aws_lb" "lb" {
  name                       = "lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.lb-sg-id]
  subnets                    = [var.subnet-internet-a-id, var.subnet-internet-b-id]
  drop_invalid_header_fields = true
  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.s3_access_logs_bucket.bucket
  }
}

module "waf" {
  source  = "umotif-public/waf-webaclv2/aws"
  version = "~> 4.2"

  name_prefix = "waf"
  alb_arn     = aws_lb.lb.arn

  scope = "REGIONAL"

  create_alb_association = true

  allow_default_action = true # set to allow if not specified

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "aws-waf-main-metrics"
    sampled_requests_enabled   = true
  }

  create_logging_configuration = true
  log_destination_configs      = [aws_cloudwatch_log_group.web-logs.arn]

  rules = [
    {
      name     = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority = "0"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesAmazonIpReputationList-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    },
    {
      name            = "AWS-AWSManagedRulesCommonRuleSet"
      priority        = "1"
      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        rule_action_override = {
          action_to_use = {
            allow = {}
          }

          name = "SizeRestrictions_BODY"
        }
        excluded_rules = [
          {
            name = "SizeRestrictions_BODY"
          }
        ]
      }
    },
    {
      name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority = "2"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWS-AWSManagedRulesLinuxRuleSet"
      priority = "4"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesLinuxRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWS-AWSManagedRulesUnixRuleSet"
      priority = "5"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesUnixRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWS-AWSManagedRulesSQLiRuleSet"
      priority = "6"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesSQLiRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    },
    ### Geo Match Rule example
    {
      name     = "GeoMatchRestOfWorldOneRule"
      priority = "10"

      action = "block"

      visibility_config = {
        metric_name = "GeoMatchRule-metric"
      }

      geo_match_statement = {
        country_codes = ["AF", "AX", "AL", "DZ", "AS", "AD", "AO", "AI", "AQ", "AG", "AR", "AM", "AW", "AU", "AT", "AZ", "BS", "BH", "BD", "BB", "BY", "BE", "BZ", "BJ", "BM", "BT", "BO", "BQ", "BA", "BW", "BV", "BR", "IO", "BN", "BG", "BF", "BI", "KH", "CM", "CA", "CV", "KY", "CF", "TD", "CL", "CN", "CX", "CC", "CO", "KM"]
      }
    },
    {
      name     = "GeoMatchRestOfWorldTwoRule"
      priority = "11"

      action = "block"

      visibility_config = {
        metric_name = "GeoMatchRule-metric"
      }

      geo_match_statement = {
        country_codes = ["CG", "CD", "CK", "CR", "CI", "HR", "CU", "CW", "CY", "CZ", "DK", "DJ", "DM", "DO", "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FO", "FJ", "FI", "FR", "GF", "PF", "TF", "GA", "GM", "GE", "DE", "GH", "GI", "GR", "GL", "GD", "GP", "GU", "GT", "GG", "GN", "GW", "GY", "HT", "HM", "VA", "HN", "HK"]
      }
    },
    {
      name     = "GeoMatchRestOfWorldThreeRule"
      priority = "12"

      action = "block"

      visibility_config = {
        metric_name = "GeoMatchRule-metric"
      }

      geo_match_statement = {
        country_codes = ["HU", "IS", "ID", "IR", "IQ", "IE", "IM", "IL", "IT", "JM", "JP", "JE", "JO", "KZ", "KE", "KI", "KP", "KR", "KW", "KG", "LA", "LV", "LB", "LS", "LR", "LY", "LI", "LT", "LU", "MO", "MK", "MG", "MW", "MY", "MV", "ML", "MT", "MH", "MQ", "MR", "MU", "YT", "MX", "FM", "MD", "MC", "MN", "ME", "MS"]
      }
    },
    {
      name     = "GeoMatchRestOfWorldFourRule"
      priority = "13"

      action = "block"

      visibility_config = {
        metric_name = "GeoMatchRule-metric"
      }

      geo_match_statement = {
        country_codes = ["MA", "MZ", "MM", "NA", "NR", "NP", "NC", "NZ", "NI", "NE", "NG", "NU", "NF", "MP", "NO", "OM", "PK", "PW", "PS", "PA", "PG", "PY", "PE", "PH", "PN", "PL", "PT", "PR", "QA", "RE", "RO", "RU", "RW", "BL", "SH", "KN", "LC", "MF", "PM", "VC", "WS", "SM", "ST", "SA", "SN", "RS", "SC", "SL"]
      }
    },
    {
      name     = "GeoMatchRestOfWorldFiveRule"
      priority = "14"

      action = "block"

      visibility_config = {
        metric_name = "GeoMatchRule-metric"
      }

      geo_match_statement = {
        country_codes = ["SX", "SK", "SI", "SB", "SO", "ZA", "GS", "SS", "ES", "LK", "SD", "SR", "SJ", "SZ", "SE", "CH", "SY", "TW", "TJ", "TZ", "TH", "TL", "TG", "TK", "TO", "TT", "TN", "TR", "TM", "TC", "TV", "UG", "UA", "AE", "GB", "UM", "UY", "UZ", "VU", "VE", "VN", "VG", "VI", "WF", "EH", "YE", "ZM", "ZW", "XK"]
      }
    },
  ]
}
resource "aws_cloudwatch_log_group" "web-logs" {
  name              = "aws-waf-logs-${random_id.s3_access_logs_bucket_id.hex}"
  retention_in_days = 365
}
