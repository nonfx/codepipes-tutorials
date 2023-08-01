locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.number}"
}

resource "aws_vpc_endpoint" "ecr-dkr-vpc-endpoint" {
  vpc_id            = var.vpc-id
  service_name      = "com.amazonaws.ap-south-1.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.vpc-endpoint-sg-id,
  ]

  subnet_ids = [
    var.subnet-internet-a-id,
    var.subnet-internet-b-id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_vpc_endpoint" "ecr-api-vpc-endpoint" {
  vpc_id            = var.vpc-id
  service_name      = "com.amazonaws.ap-south-1.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.vpc-endpoint-sg-id,
  ]

  subnet_ids = [
    var.subnet-internet-a-id,
    var.subnet-internet-b-id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

resource "aws_vpc_endpoint" "s3-vpc-endpoint" {
  vpc_id          = var.vpc-id
  service_name    = "com.amazonaws.ap-south-1.s3"
  route_table_ids = [var.route-table-internet-a-id, var.route-table-internet-b-id]

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_vpc_endpoint" "logs-vpc-endpoint" {
  vpc_id            = var.vpc-id
  service_name      = "com.amazonaws.ap-south-1.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.vpc-endpoint-sg-id,
  ]

  subnet_ids = [
    var.subnet-internet-a-id,
    var.subnet-internet-b-id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_vpc_endpoint" "ssm-vpc-endpoint" {
  vpc_id            = var.vpc-id
  service_name      = "com.amazonaws.ap-south-1.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.vpc-endpoint-sg-id,
  ]

  subnet_ids = [
    var.subnet-internet-a-id,
    var.subnet-internet-b-id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_vpc_endpoint" "ec2messages-vpc-endpoint" {
  vpc_id            = var.vpc-id
  service_name      = "com.amazonaws.ap-south-1.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.vpc-endpoint-sg-id,
  ]

  subnet_ids = [
    var.subnet-internet-a-id,
    var.subnet-internet-b-id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_vpc_endpoint" "ssmmessages-vpc-endpoint" {
  vpc_id            = var.vpc-id
  service_name      = "com.amazonaws.ap-south-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.vpc-endpoint-sg-id,
  ]

  subnet_ids = [
    var.subnet-internet-a-id,
    var.subnet-internet-b-id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}