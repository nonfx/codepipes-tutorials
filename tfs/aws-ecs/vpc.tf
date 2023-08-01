#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "demo" {
  cidr_block = var.cluster_ipv4_cidr
  enable_dns_hostnames   = true
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.demo.id
}

resource "aws_subnet" "demo" {
  depends_on = [aws_vpc.demo]
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.demo.id

}

resource "aws_subnet" "dbsubnet" {
  depends_on=[aws_vpc.demo]
  count = 2
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.${count.index + 2}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

resource "aws_internet_gateway" "demo" {
  depends_on = [aws_vpc.demo]
  vpc_id = aws_vpc.demo.id

}

resource "aws_route_table" "demo" {
  depends_on = [aws_internet_gateway.demo]
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
}

resource "aws_route_table_association" "demo" {
  depends_on = [aws_route_table.demo]
  count = 2

  subnet_id      = aws_subnet.demo.*.id[count.index]
  route_table_id = aws_route_table.demo.id
}
