locals {
  extract_resource_name = "${var.common_name_prefix}-${var.environment}"
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "${local.extract_resource_name}-api-gateway"
  description = "API Gateway for ${local.extract_resource_name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

# Create API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_method.method
  ]

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = var.environment

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.proxy_resource.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Associate the API key with the usage plan
resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}


# Create API Gateway API Key
resource "aws_api_gateway_api_key" "api_key" {
  name        = var.api_key_name
  description = "API key for accessing the API"
  enabled     = true
  value       = random_id.random_api_key.id
}


# Create API Gateway Usage Plan
resource "aws_api_gateway_usage_plan" "usage_plan" {
  name        = "${local.extract_resource_name}-usage-plan"
  description = "Usage plan for ${local.extract_resource_name} API"

  product_code = local.extract_resource_name

  api_stages {
    api_id = aws_api_gateway_rest_api.api_gateway.id
    stage  = aws_api_gateway_deployment.deployment.stage_name
  }
}

# Create random pet for API key value
resource "random_id" "random_api_key" {
  byte_length = 72
  prefix      = "api-key-"
}


# Create IAM role for API Gateway to access ECS
resource "aws_iam_role" "api_gateway_role" {
  name = "${local.extract_resource_name}-api-gateway-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "api_gateway_ecs_attachment" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"

  depends_on = [aws_iam_role.api_gateway_role]
}

resource "aws_iam_role_policy_attachment" "api_gateway_ecs_execution_role_attachment" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"

  depends_on = [aws_iam_role.api_gateway_role]
}

# Create a proxy resource that captures all subpaths
resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             =  aws_api_gateway_resource.proxy_resource.id
  http_method             = "ANY"
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "${var.backend_uri}/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  depends_on = [aws_api_gateway_method.method]
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.proxy" = true
  }

}


# Create API Gateway custom domain name
resource "aws_api_gateway_domain_name" "domain_name" {
  domain_name              = var.custom_domain_name
  regional_certificate_arn = var.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

# Create API Gateway base path mapping
resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
  domain_name = aws_api_gateway_domain_name.domain_name.id
  api_id      = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = aws_api_gateway_deployment.deployment.stage_name
}


