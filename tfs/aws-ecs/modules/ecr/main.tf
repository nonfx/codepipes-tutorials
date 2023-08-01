locals {
  extract_resource_name = lower("${var.common_name_prefix}-${var.environment}-ecr")
}

resource "aws_ecr_repository" "main" {

  name                 = lower("${var.common_name_prefix}-${var.app}-ecr")
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.enable_force_delete

  image_scanning_configuration {
    scan_on_push = var.enable_scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  tags = merge(
    {
      "Name" = format("%s", local.extract_resource_name)
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

data "aws_caller_identity" "current" {}

data "aws_regions" "current" {}

# resource "aws_ecr_replication_configuration" "main" {
#   count = (var.environment == "production" || var.environment == "prod" ? 1 : 0)
#   replication_configuration {
#     rule {
#       destination {
#         region      = tolist(data.aws_regions.current.names)[0]
#         registry_id = data.aws_caller_identity.current.account_id
#       }
#     }
#   }
# }


# #Lifecycle Policy

resource "aws_ecr_lifecycle_policy" "foopolicy" {

  repository = aws_ecr_repository.main.name
  
  policy = <<EOF
            {
              "rules": [
                {
                  "rulePriority": 10,
                  "description": "For `latest` tag, keep last 5 images",
                  "selection": {
                    "tagStatus": "tagged",
                    "tagPrefixList": ["latest"],
                    "countType": "imageCountMoreThan",
                    "countNumber": 5
                  },
                  "action": { "type": "expire" }
                },
                {
                  "rulePriority": 20,
                  "description": "For `master` tag, keep last 5 images",
                  "selection": {
                    "tagStatus": "tagged",
                    "tagPrefixList": ["master"],
                    "countType": "imageCountMoreThan",
                    "countNumber": 5
                  },
                  "action": { "type": "expire" }
                },
                {
                  "rulePriority": 990,
                  "description": "Only keep untagged images for 7 days",
                  "selection": {
                    "tagStatus": "untagged",
                    "countType": "sinceImagePushed",
                    "countUnit": "days",
                    "countNumber": 7
                  },
                  "action": { "type": "expire" }
                },
                {
                  "rulePriority": 1000,
                  "description": "Only keep tagged images for 15 days",
                  "selection": {
                    "tagStatus": "any",
                    "countType": "sinceImagePushed",
                    "countUnit": "days",
                    "countNumber": 15
                  },
                  "action": { "type": "expire" }
                }
              ]
            }
EOF
}

locals {
  current_account_statement = {
    Sid       = "AllowAllActionsFromCurrentAccount"
    Effect    = "Allow"
    Principal = {
      AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    }
    Action = [
      "ecr:*"
    ]
  }

  additional_account_statement = var.additional_ecr_access_account_id != null ? {
    Sid       = "AllowAllActionsFromAdditionalAWSAccount"
    Effect    = "Allow"
    Principal = {
      AWS = "arn:aws:iam::${var.additional_ecr_access_account_id}:root"
    }
    Action = [
      "ecr:*"
    ]
  } : null

  statements = concat([local.current_account_statement], [for statement in [local.additional_account_statement] : statement if statement != null])
}

resource "aws_ecr_repository_policy" "example" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = local.statements
  })
}



