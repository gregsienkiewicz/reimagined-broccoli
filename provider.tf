terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
  }

  backend "s3" {
    encrypt              = true
    workspace_key_prefix = "tf-workspace"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      github = "reimagined-broccoli"
    }
  }
}
