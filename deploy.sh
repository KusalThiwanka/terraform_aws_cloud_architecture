#!/bin/bash

# Deploy Development Network:
cd dev/network
terraform init
terraform apply -auto-approve

# Deploy Development Webservers
cd ../webservers
ssh-keygen -t rsa  -f devkeypair -N ""
terraform init
terraform apply -auto-approve

# Deploy the Production Network
cd ../../prod/network
terraform init
terraform apply -auto-approve

# Deploy Production Webservers
cd ../webservers
ssh-keygen -t rsa  -f prodkeypair -N ""
terraform init
terraform apply -auto-approve

# Deploy VPC Peering Connection
cd ../../vpc_peering
terraform init
terraform apply -auto-approve

# Deploy Application Load Balancer
cd ../alb
terraform init
terraform apply -auto-approve