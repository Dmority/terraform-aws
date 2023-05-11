output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "value of vpc_id"
}

output "vpc_public_subnets" {
  value       = module.vpc.public_subnets
  description = "value of vpc_public_subnets"
}

output "vpc_private_subnets" {
  value       = module.vpc.private_subnets
  description = "value of vpc_private_subnets"
}
