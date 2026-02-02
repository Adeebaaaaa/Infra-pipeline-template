# vpc module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.cluster_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway      = false
  single_nat_gateway      = false
  map_public_ip_on_launch = true

  tags = {
    Environment = var.environment
  }
}
#EKS MODULE
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = false

  eks_managed_node_groups = {
    default = {
      subnet_ids               = module.vpc.public_subnets
      instance_types           = var.node_instance_types
      iam_role_use_name_prefix = false
      name                     = "${var.cluster_name}-${var.environment}"
      ami_type                 = "AL2_x86_64"
      desired_size             = var.node_desired_size
      min_size                 = var.node_min_size
      max_size                 = var.node_max_size
    }
  }
  tags = {
    Environment = var.environment
  }
}

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.0.0"

#   cluster_name    = var.cluster_name
#   cluster_version = var.kubernetes_version

#   vpc_id                   = module.vpc.vpc_id
#   subnet_ids               = module.vpc.public_subnets
#   control_plane_subnet_ids = module.vpc.public_subnets


#   create_kms_key            = false
#   cluster_encryption_config = {}
#   cluster_addons            = {}
#   enable_irsa               = false
#   manage_aws_auth_configmap = true


# eks_managed_node_groups = {
#   default = {
#     subnet_ids               = module.vpc.public_subnets
#     instance_types           = var.node_instance_types
#     iam_role_use_name_prefix = false
#     name                     = "${var.cluster_name}-${var.environment}"
#     ami_type                 = "AL2_x86_64"
#     desired_size             = var.node_desired_size
#     min_size                 = var.node_min_size
#     max_size                 = var.node_max_size
#   }
# }

#   tags = {
#     Environment = var.environment
#   }
# }


# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.0.0"

#   cluster_name    = var.cluster_name
#   cluster_version = var.kubernetes_version

#   vpc_id                   = module.vpc.vpc_id
#   subnet_ids               = module.vpc.private_subnets
#   control_plane_subnet_ids = module.vpc.private_subnets

#   cluster_enabled_log_types = []


#   create_kms_key            = false
#   cluster_encryption_config = {}
#   cluster_addons            = {}
#   enable_irsa               = false

#   tags = {
#     Environment = var.environment
#   }
# }


