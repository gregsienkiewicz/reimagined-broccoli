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

  access_key = "AKIASJRLZOCXRUOMMD7E"
  secret_key = "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"

  default_tags {
    tags = {
      github = "reimagined-broccoli"
    }
  }
}
