terraform {
  cloud {
    organization = "dnahpc_terraform_learn"
    workspaces {
      name = "aws-my-static-website"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
  required_version = ">=1.5.3"
}
