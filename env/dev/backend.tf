terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
      bucket = "${BACKEND_BUCKET}"
      key    = "terraform.state"
      region = "ap-northeast-1"
  }
}
