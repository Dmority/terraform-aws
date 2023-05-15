################################################################################
# Aurora Password
################################################################################
resource "random_password" "aurora_postgresql_master_password" {
  length  = 16
  special = false
}

################################################################################
# KMS Key
################################################################################
module "kms_secrets_manager_for_rds" {
  source  = "terraform-aws-modules/kms/aws"
  version = "1.5.0"

  description        = "KMS key for RDS secrets"
  key_owners         = ["arn:aws:iam::${local.account_id}:role/GithubActions", "arn:aws:iam::${local.account_id}:user/mac-morita"]
  key_administrators = ["arn:aws:iam::${local.account_id}:role/GithubActions", "arn:aws:iam::${local.account_id}:user/mac-morita"]

  aliases                 = ["${local.prefix}/secrets-manager/rds"]
  aliases_use_name_prefix = true
}

################################################################################
# Secrets Manager
################################################################################
resource "aws_secretsmanager_secret" "aurora_postgresql_master_password" {
  name       = "${local.prefix}-aurora-postgresql-master-password"
  kms_key_id = module.kms_secrets_manager_for_rds.key_arn
}

resource "aws_secretsmanager_secret_version" "aurora_postgresql_master_password" {
  secret_id     = aws_secretsmanager_secret.aurora_postgresql_master_password.id
  secret_string = random_password.aurora_postgresql_master_password.result
}

################################################################################
# PostgreSQL Serverless v1
################################################################################
module "aurora_postgresql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.1.1"

  name              = "${local.prefix}-aurora-postgresql"
  engine            = "aurora-postgresql"
  engine_mode       = "serverless"
  storage_encrypted = true

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 16
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }

  manage_master_user_password = false
  master_username             = "master_user"
  master_password             = random_password.aurora_postgresql_master_password.result
}
