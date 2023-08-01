locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.number}"
}

# Create security groups
resource "aws_security_group" "lb-sg" {
  name        = "${local.extract_resource_name}-lb-sg"
  description = "${local.extract_resource_name}-lb-sg"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 444
    to_port     = 444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-lb-sg")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_security_group" "web-sg" {
  name        = "${local.extract_resource_name}-web-sg"
  description = "${local.extract_resource_name}-web-sg"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-web-sg")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_security_group" "app-sg" {
  name        = "${local.extract_resource_name}-app-sg"
  description = "${local.extract_resource_name}-app-sg"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 444
    to_port     = 444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-app-sg")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_security_group" "db-sg" {
  name        = "${local.extract_resource_name}-db-sg"
  description = "${local.extract_resource_name}-db-sg"
  vpc_id      = var.vpc-id
  #Postgres Default Port
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app-sg.id]
  }
  #DocumentDB Default Port
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.app-sg.id]
  }
  #Redis Default Port
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.app-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-db-sg")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_security_group" "vpc-endpoint-sg" {
  name        = "${local.extract_resource_name}-vpc-endpoint-sg"
  description = "${local.extract_resource_name}-vpc-endpoint-sg"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web-sg.id, aws_security_group.app-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-endpoint-sg")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}