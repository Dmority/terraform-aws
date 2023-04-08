provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      repo       = "Dmority/terraform-aws"
      ManagedBy  = "terraform"
      CostCenter = "poc"
    }
  }
}
