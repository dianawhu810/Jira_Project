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
# Public Subnet
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
