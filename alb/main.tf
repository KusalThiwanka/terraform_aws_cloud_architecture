# provider "aws" {
#   profile = "default"
#   region  = "us-east-1"
# }

# # Define required providers
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
#   required_version = ">=0.14"
# }

# This is to use Outputs from Dev Network Remote State 
data "terraform_remote_state" "dev_network" {
  backend = "s3"
  config = {
    bucket = "kusal-assignment1"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# This is to use Outputs from Dev Webservers Remote State 
data "terraform_remote_state" "dev_webservers" {
  backend = "s3"
  config = {
    bucket = "kusal-assignment1"
    key    = "dev/webservers/terraform.tfstate"
    region = "us-east-1"
  }
}

module "alb" {
  source     = "../Modules/aws_alb"
  env        = var.env
  prefix     = var.prefix
  vpc_id     = data.terraform_remote_state.dev_network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.dev_network.outputs.public_subnet_ids
  webserver_ids = data.terraform_remote_state.dev_webservers.outputs.webserver_ids
}