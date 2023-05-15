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

  kms_key_owners         = ["arn:aws:iam::${local.account_id}:role/GithubActions"]
  kms_key_administrators = ["arn:aws:iam::${local.account_id}:role/GithubActions"]
}
