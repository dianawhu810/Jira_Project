variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "subnet_cidr1" {
  type = string
}

variable "subnet_cidr2" {
  type = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, stage, prod)"
  type        = string
}