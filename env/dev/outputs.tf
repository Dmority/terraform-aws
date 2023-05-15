################################################################################
# Common
################################################################################

################################################################################
# Network
################################################################################
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

output "vpc_database_subnets" {
  value       = module.vpc.database_subnets
  description = "value of vpc_database_subnets"
}

################################################################################
# Compute
################################################################################

################################################################################
# Storage
################################################################################
output "s3_logs_bucket_id" {
  value       = module.s3_logs.s3_bucket_id
  description = "value of s3_logs_bucket_id"
}

################################################################################
# Database
################################################################################
output "aurora_cluster_endpoint" {
  value       = module.aurora_postgresql.cluster_endpoint
  description = "value of aurora cluster endpoint"
}

output "aurora_cluster_reader_endpoint" {
  value       = module.aurora_postgresql.cluster_reader_endpoint
  description = "value of aurora reader endpoint"
}

output "aurora_security_group_id" {
  value       = module.aurora_postgresql.security_group_id
  description = "value of aurora security group id"
}
