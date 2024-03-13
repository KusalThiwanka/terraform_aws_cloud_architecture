variable "peer_region" {}
variable "requestor_vpc_id" {}
variable "acceptor_vpc_id" {}


data "aws_vpc" "requestor" {
  id = var.requestor_vpc_id
}

data "aws_route_tables" "requestor" {
  vpc_id = var.requestor_vpc_id
}

data "aws_vpc" "acceptor" {
  id = var.acceptor_vpc_id
}

data "aws_route_tables" "acceptor" {
  vpc_id = var.acceptor_vpc_id
}

data "aws_caller_identity" "peer" {}