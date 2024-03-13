# Define required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">=0.14"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# This is to use Outputs from Remote State
data "terraform_remote_state" "prod_data" {
  backend = "s3"
  config = {
    bucket = "kusal-assignment1"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# This is to use Outputs from Remote State
data "terraform_remote_state" "dev_data" {
  backend = "s3"
  config = {
    bucket = "kusal-assignment1"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc-peering-same-account-1-account2" {
  source           = "../Modules/aws_vpc_peering"
  requestor_vpc_id = data.terraform_remote_state.dev_data.outputs.vpc_id
  acceptor_vpc_id  = data.terraform_remote_state.prod_data.outputs.vpc_id
  peer_region      = "us-east-1"
}