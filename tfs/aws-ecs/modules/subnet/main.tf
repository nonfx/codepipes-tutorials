locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.number}"
}


resource "aws_subnet" "subnet-firewall-a" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.0.0/28"
  availability_zone = "ap-south-1a"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-firewall-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-firewall-b" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.1.0/28"
  availability_zone = "ap-south-1b"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-firewall-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-internet-a" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.2.0/24"
  availability_zone = "ap-south-1a"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-internet-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-internet-b" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.3.0/24"
  availability_zone = "ap-south-1b"


  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-internet-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-web-a" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.4.0/24"
  availability_zone = "ap-south-1a"


  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-web-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-web-b" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.5.0/24"
  availability_zone = "ap-south-1b"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-web-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-app-a" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.6.0/24"
  availability_zone = "ap-south-1a"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-app-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-app-b" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.7.0/24"
  availability_zone = "ap-south-1b"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-app-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-db-a" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.8.0/24"
  availability_zone = "ap-south-1a"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-db-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_subnet" "subnet-db-b" {
  vpc_id = var.vpc-id

  cidr_block        = "10.1.9.0/24"
  availability_zone = "ap-south-1b"

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-subnet-db-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}