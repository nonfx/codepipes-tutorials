locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.number}"
}


resource "aws_network_acl" "firewall-nacl" {
  vpc_id = var.vpc-id

  subnet_ids = [
    var.subnet-firewall-a-id,
    var.subnet-firewall-b-id,
  ]

  # Allow HTTP traffic from internet
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allow HTTPS traffic from internet 
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow internet traffic from Internet Subnet A
  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "10.1.2.0/24"
    from_port  = 443
    to_port    = 443
  }

  # Allow internet traffic from Internet Subnet A
  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "10.1.3.0/24"
    from_port  = 443
    to_port    = 443
  }

  # Allow return of internet traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

    # Allow digio traffic
    ingress {
      protocol   = "tcp"
      rule_no    = 105
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 444
      to_port    = 444
    }

  # Allow return of internet traffic from VPC
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow internet traffic
  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow HTTP redireect traffic
  egress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }


  # Allow digio traffic
  egress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 444
    to_port    = 444
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-firewall-nacl")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_network_acl" "internet-nacl" {
  vpc_id = var.vpc-id

  subnet_ids = [
    var.subnet-internet-a-id,
    var.subnet-internet-b-id,
  ]

  # Allow HTTP traffic from internet
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allow HTTPS traffic from internet 
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow internet traffic from Web Subnet A
  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "10.1.4.0/24"
    from_port  = 443
    to_port    = 443
  }

  # Allow internet traffic from Web Subnet B
  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "10.1.5.0/24"
    from_port  = 443
    to_port    = 443
  }

  # Allow internet traffic from App Subnet A
  ingress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = "10.1.6.0/24"
    from_port  = 443
    to_port    = 443
  }

  # Allow internet traffic from App Subnet B
  ingress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = "10.1.7.0/24"
    from_port  = 443
    to_port    = 443
  }

  # Allow return of internet traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 106
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow rdigio traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 107
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 444
    to_port    = 444
  }

  # Allow return of HTTPS traffic from internet
  # Allow return of internet traffic from VPC
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow internet traffic
  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow internet traffic
  egress {
    protocol   = "tcp"  
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"  
    rule_no    = 104
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 444
    to_port    = 444
  }

  tags = merge(
  {
    "Name" = format("%s", "${local.extract_resource_name}-internet-nacl")
  },
  {
    environment = var.environment
  },
  var.tags,
  )
}

resource "aws_network_acl" "web-nacl" {
  vpc_id = var.vpc-id

  subnet_ids = [
    var.subnet-web-a-id,
    var.subnet-web-b-id,
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.1.2.0/24"
    from_port  = 2000
    to_port    = 2000
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "10.1.3.0/24"
    from_port  = 2000
    to_port    = 2000
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.1.2.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "10.1.3.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-web-nacl")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_network_acl" "app-nacl" {
  vpc_id = var.vpc-id

  subnet_ids = [
    var.subnet-app-a-id,
    var.subnet-app-b-id,
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.1.2.0/24"
    from_port  = 2012
    to_port    = 2012
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "10.1.3.0/24"
    from_port  = 2012
    to_port    = 2012
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "10.1.8.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = "10.1.9.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  # Add ingress rule for HTTP traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Add ingress rule for Digio traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 106
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 444
    to_port    = 444
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.1.2.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "10.1.3.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "10.1.8.0/24"
    from_port  = 5432
    to_port    = 5432
  }

  egress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "10.1.9.0/24"
    from_port  = 5432
    to_port    = 5432
  }

  egress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = "10.1.8.0/24"
    from_port  = 27017
    to_port    = 27017
  }

  egress {
    protocol   = "tcp"
    rule_no    = 107
    action     = "allow"
    cidr_block = "10.1.8.0/24"
    from_port  = 6379
    to_port    = 6379
  }

  egress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = "10.1.9.0/24"
    from_port  = 27017
    to_port    = 27017
  }

  egress {
    protocol   = "tcp"
    rule_no    = 108
    action     = "allow"
    cidr_block = "10.1.9.0/24"
    from_port  = 6379
    to_port    = 6379
  }

  egress {
    protocol   = "tcp"
    rule_no    = 106
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Add egress rule for HTTP traffic
  egress {
    protocol   = "tcp"
    rule_no    = 109
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Add egress rule for digio traffic
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 444
    to_port    = 444
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-app-nacl")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_network_acl" "db-nacl" {
  vpc_id = var.vpc-id

  subnet_ids = [
    var.subnet-db-a-id,
    var.subnet-db-b-id,
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.1.6.0/24"
    from_port  = 5432
    to_port    = 5432
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "10.1.7.0/24"
    from_port  = 5432
    to_port    = 5432
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "10.1.6.0/24"
    from_port  = 27017
    to_port    = 27017
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = "10.1.6.0/24"
    from_port  = 6379
    to_port    = 6379
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "10.1.7.0/24"
    from_port  = 27017
    to_port    = 27017
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = "10.1.7.0/24"
    from_port  = 6379
    to_port    = 6379
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.1.6.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "10.1.7.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-db-nacl")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}