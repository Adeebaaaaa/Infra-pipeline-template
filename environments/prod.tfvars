environment  = "prod"
cluster_name = "eks-prod"

aws_region = "us-east-1"

vpc_cidr = "10.1.0.0/24"
azs      = ["us-east-1b"]

public_subnets  = ["10.1.0.0/26"]
private_subnets = ["10.1.0.64/26"]

enable_nodes = false
