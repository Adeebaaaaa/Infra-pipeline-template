environment  = "dev"
cluster_name = "dev-test-destroy"



aws_region = "us-east-1"

vpc_cidr = "10.0.0.0/24"

azs = ["us-east-1a", "us-east-1b"]

private_subnets = ["10.0.0.0/26", "10.0.0.64/26"]
public_subnets  = ["10.0.0.128/26", "10.0.0.192/26"]

node_instance_types = ["t3.small"]
node_desired_size   = 1
node_min_size       = 1
node_max_size       = 2