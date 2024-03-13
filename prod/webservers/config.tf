provider "aws" {
  profile = var.profile
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }
  required_version = ">=0.14"
}

terraform {
  backend "s3" {
    bucket = "kusal-assignment1"
    key    = "prod/webservers/terraform.tfstate"
    region = "us-east-1"
  }
}
