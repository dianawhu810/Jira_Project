terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# -----------------------
# VPC
# -----------------------
resource "aws_vpc" "ProdVPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ProdVPC"
  }
}

# -----------------------
# Internet Gateway
# -----------------------
resource "aws_internet_gateway" "ProdVPCIGW" {
  vpc_id = aws_vpc.ProdVPC.id

  tags = {
    Name = "ProdVPCIGW"
  }
}

# -----------------------
# Public Subnet 1
# -----------------------
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.ProdVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet1"
  }
}

# -----------------------
# Public Subnet 2
# -----------------------
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.ProdVPC.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "public-subnet2"
  }
}

# -----------------------
# Route Table (Public)
# -----------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.ProdVPC.id

  tags = {
    Name = "public_rtb"
  }
}

# -----------------------
# Default Route to Internet
# -----------------------
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ProdVPCIGW.id
}

# -----------------------
# Route Table Association
# -----------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_assoc2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public_rtb.id
}

# -----------------------
# Security Group
# -----------------------
resource "aws_security_group" "ProdVPC_SG" {
  name        = "ProdVPC_SG"
  description = "Security group for ProdVPC"
  vpc_id      = aws_vpc.ProdVPC.id

  # Ingress rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ProdVPC_SG"
  }
}
