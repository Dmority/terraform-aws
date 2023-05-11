################################################################################
# VPC
################################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "${local.prefix}-vpc"
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
}

################################################################################
# Security Groups
################################################################################
module "sg_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"

  name        = "${local.prefix}-alb"
  description = "Security group for ALB"

  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

}
