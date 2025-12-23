aws_region = "us-east-1"

vpc_name = "ProdVPC"
vpc_cidr = "10.0.1.0/16"

public_subnet_1_cidr = "10.0.0.0/24"
public_subnet_2_cidr = "10.0.2.0/24"

public_subnet_1_az = "us-east-1a"
public_subnet_2_az = "us-east-1b"

igw_name = "ProdVPCIGW"

public_route_table_name = "public_rtb"

security_group_name = "ProdVPC_SG"

ssh_allowed_cidr  = ["0.0.0.0/0"]
http_allowed_cidr = ["0.0.0.0/0"]
