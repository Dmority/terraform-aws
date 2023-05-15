################################################################################
# EKS
################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.1"

  cluster_name    = "${local.prefix}-eks-main"
  cluster_version = "1.26"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  kms_key_owners         = ["arn:aws:iam::${local.account_id}:role/GithubActions", "arn:aws:iam::${local.account_id}:user/mac-morita"]
  kms_key_administrators = ["arn:aws:iam::${local.account_id}:role/GithubActions", "arn:aws:iam::${local.account_id}:user/mac-morita"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }
  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
  }

  # Create a new cluster where both an identity provider and Fargate profile is created
  # will result in conflicts since only one can take place at a time
  # # OIDC Identity provider
  cluster_identity_providers = {
    sts = {
      client_id = "sts.amazonaws.com"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${local.account_id}:role/GithubActions"
      username = "GithubActions"
      groups   = ["system:masters"]
    },
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/mac-morita"
      username = "mac-morita"
      groups   = ["system:masters"]
    },
  ]
}

