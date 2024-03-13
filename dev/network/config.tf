terraform {
  backend "s3" {
    bucket = "kusal-assignment1"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}