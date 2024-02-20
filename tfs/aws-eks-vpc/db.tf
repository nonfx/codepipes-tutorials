resource "aws_db_subnet_group" "database" {
  depends_on =[aws_subnet.dbsubnet]
  name       = "aws_db_subnet_group-demo-${random_string.role.id}"
  subnet_ids = aws_subnet.dbsubnet[*].id
  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_security_group" "dbsg" {
  depends_on =[aws_subnet.dbsubnet]
  name        = "db-${random_string.role.id}"
  description = "security group for db"
  vpc_id      = aws_vpc.demo.id


  # Allowing traffic only for Postgres and that too from same VPC only.
  ingress {
    description = "POSTGRES"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.cluster_ipv4_cidr]
  }


  # Allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}
