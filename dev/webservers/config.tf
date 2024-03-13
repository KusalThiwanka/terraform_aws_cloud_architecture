provider "aws" {
  profile = "default"
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
    key    = "dev/webservers/terraform.tfstate"
    region = "us-east-1"
  }
}
