data "aws_caller_identity" "current" {}

locals {
  system            = var.common_system
  env               = terraform.workspace
  prefix            = "${local.system}-${local.env}"
  prefix_with_slash = "/${local.system}/${local.env}"
  account_id        = data.aws_caller_identity.current.account_id
}
