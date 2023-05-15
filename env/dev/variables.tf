################################################################################
# Common
################################################################################
variable "common_system" {
  type        = string
  description = "System Name"
}

################################################################################
# Network
################################################################################
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}
variable "vpc_azs" {
  type        = list(string)
  description = "Availabirity Zone"
}
variable "vpc_private_subnets" {
  type        = list(string)
  description = "Private Subnets CIDR"
}
variable "vpc_public_subnets" {
  type        = list(string)
  description = "Public Subnets CIDR"
}

variable "vpc_database_subnets" {
  type        = list(string)
  description = "Database Subnets CIDR"
}

################################################################################
# Compute
################################################################################

################################################################################
# Storage
################################################################################

################################################################################
# Database
################################################################################
