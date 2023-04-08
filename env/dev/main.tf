data "aws_caller_identity" "current" {}

locals {
  system            = "sample"
  env               = "dev"
  prefix            = "${local.system}-${local.env}"
  prefix_with_slash = "/${local.system}/${local.env}"
  account_id        = data.aws_caller_identity.current.account_id
}
