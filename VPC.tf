terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -----------------------
# Provider
# -----------------------
provider "aws" {
  region = var.aws_region
}

# -----------------------
# VPC
# -----------------------
resource "aws_vpc" "prod_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# -----------------------
# Internet Gateway
# -----------------------
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = var.igw_name
  }
}

# -----------------------
# Public Subnet 1
# -----------------------
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.public_subnet_1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

# -----------------------
# Public Subnet 2
# -----------------------
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.public_subnet_2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

# -----------------------
# Route Table (Public)
# -----------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = var.public_route_table_name
  }
}

# -----------------------
# Default Route to Internet
# -----------------------
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod_igw.id
}

# -----------------------
# Route Table Associations
# -----------------------
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rtb.id
}

# -----------------------
# Security Group
# -----------------------
resource "aws_security_group" "prod_sg" {
  name        = var.security_group_name
  description = "Security group for ${var.vpc_name}"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidr
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_allowed_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}
