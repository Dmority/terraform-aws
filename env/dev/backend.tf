terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "remote" {
    organization = "example-org-3454eb"
    workspaces {
      name = "terraform-aws"
    }
  }
}
