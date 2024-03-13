terraform {
  backend "s3" {
    bucket = "kusal-assignment1"
    key    = "vpc_peering/terraform.tfstate"
    region = "us-east-1"
  }
}