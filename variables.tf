# -----------------------
# General
# -----------------------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# -----------------------
# VPC
# -----------------------
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "ProdVPC"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# -----------------------
# Subnets
# -----------------------
variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_1_az" {
  description = "Availability Zone for public subnet 1"
  type        = string
  default     = "us-east-1a"
}

variable "public_subnet_2_az" {
  description = "Availability Zone for public subnet 2"
  type        = string
  default     = "us-east-1b"
}

# -----------------------
# Internet Gateway
# -----------------------
variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
  default     = "ProdVPCIGW"
}

# -----------------------
# Route Table
# -----------------------
variable "public_route_table_name" {
  description = "Name of the public route table"
  type        = string
  default     = "public_rtb"
}

# -----------------------
# Security Group
# -----------------------
variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "ProdVPC_SG"
}

variable "ssh_allowed_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_allowed_cidr" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
