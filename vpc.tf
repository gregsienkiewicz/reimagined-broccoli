resource "aws_vpc" "owasp" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "OWASP | VPC"
  }
}

resource "aws_internet_gateway" "owasp" {
  vpc_id = aws_vpc.owasp.id

  tags = {
    Name = "OWASP | IGW"
  }
}

resource "aws_eip" "owasp" {
  domain           = "vpc"
  public_ipv4_pool = "amazon"

  tags = {
    Name = "OWASP | EIP"
  }
}

resource "aws_nat_gateway" "owasp" {
  depends_on = [aws_internet_gateway.owasp, aws_eip.owasp]

  allocation_id = aws_eip.owasp.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "OWASP | NAT GW"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.owasp.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "OWASP | Public Subnet A"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.owasp.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "OWASP | Public Subnet B"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.owasp.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "OWASP | Private Subnet A"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.owasp.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "OWASP | Private Subnet B"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.owasp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.owasp.id
  }

  tags = {
    Name = "OWASP | Public Route Table"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.owasp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.owasp.id
  }

  tags = {
    Name = "OWASP | Private Route Table"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Allow Node port inbound traffic"
  vpc_id      = aws_vpc.owasp.id

  ingress {
    description     = "Allow ALB inbound traffic"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    description = "Allow ALB inbound traffic"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all Egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "OWASP | ECS Security Group"
  }
}

resource "aws_security_group" "lb" {
  name        = "lb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.owasp.id

  ingress {
    description = "Allow OWASP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all Egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "OWASP | LB Security Group"
  }
}
