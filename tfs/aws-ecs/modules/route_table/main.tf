locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.number}"
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc-id

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-igw")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_eip" "nat-gw-eip-a" {
  vpc = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-eip-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

resource "aws_eip" "nat-gw-eip-b" {
  vpc = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-eip-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

# Create NAT Gateway
resource "aws_nat_gateway" "nat-gw-a" {
  allocation_id = aws_eip.nat-gw-eip-a.id
  subnet_id     = var.subnet-internet-a-id

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-nat-gw-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat-gw-b" {
  allocation_id = aws_eip.nat-gw-eip-b.id
  subnet_id     = var.subnet-internet-b-id

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-nat-gw-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}

# Create route tables
resource "aws_route_table" "route-table-igw-ingress" {
  vpc_id = var.vpc-id

  route {
    cidr_block      = "10.1.2.0/24"
    vpc_endpoint_id = var.firewall-a-endpoint-id
  }

  route {
    cidr_block      = "10.1.3.0/24"
    vpc_endpoint_id = var.firewall-b-endpoint-id
  }


  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-igw-ingress")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

# Create route tables
resource "aws_route_table" "route-table-firewall-a" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}--route-table-fw-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table-firewall-b" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-route-table-fw-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table-internet-a" {
  vpc_id = var.vpc-id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = var.firewall-a-endpoint-id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-route-table-internet-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table-internet-b" {
  vpc_id = var.vpc-id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = var.firewall-b-endpoint-id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-route-table-internet-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table-web-a" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-a.id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-route-table-web-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table-web-b" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-b.id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-route-table-web-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table-app-a" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-a.id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-route-table-app-a")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route_table" "route-table-app-b" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-b.id
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-route-table-app-b")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

# Associate route tables to subnet
resource "aws_route_table_association" "route-table-association-igw-ingress" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.route-table-igw-ingress.id
}

resource "aws_route_table_association" "route-table-association-firewall-a" {
  subnet_id      = var.subnet-firewall-a-id
  route_table_id = aws_route_table.route-table-firewall-a.id
}

resource "aws_route_table_association" "route-table-association-firewall-b" {
  subnet_id      = var.subnet-firewall-b-id
  route_table_id = aws_route_table.route-table-firewall-b.id
}

resource "aws_route_table_association" "route-table-association-internet-a" {
  subnet_id      = var.subnet-internet-a-id
  route_table_id = aws_route_table.route-table-internet-a.id
}

resource "aws_route_table_association" "route-table-association-internet-b" {
  subnet_id      = var.subnet-internet-b-id
  route_table_id = aws_route_table.route-table-internet-b.id
}

resource "aws_route_table_association" "route-table-association-web-a" {
  subnet_id      = var.subnet-web-a-id
  route_table_id = aws_route_table.route-table-web-a.id
}

resource "aws_route_table_association" "route-table-association-web-b" {
  subnet_id      = var.subnet-web-b-id
  route_table_id = aws_route_table.route-table-web-b.id
}

resource "aws_route_table_association" "route-table-association-app-a" {
  subnet_id      = var.subnet-app-a-id
  route_table_id = aws_route_table.route-table-app-a.id
}

resource "aws_route_table_association" "route-table-association-app-b" {
  subnet_id      = var.subnet-app-b-id
  route_table_id = aws_route_table.route-table-app-b.id
}
