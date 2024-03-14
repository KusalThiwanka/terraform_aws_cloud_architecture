#!/bin/bash

# Destroy resources in VPC Peering Connection
cd vpc_peering
terraform destroy -auto-approve

# Destroy resources in Application Load Balancer
cd ../alb
terraform destroy -auto-approve

# Destroy resources in Development Webservers
cd ../dev/webservers
terraform destroy -auto-approve

# Destroy resources in Development Network
cd ../network
terraform destroy -auto-approve

# Destroy resources in Production Webservers
cd ../../prod/webservers
terraform destroy -auto-approve

# Destroy resources in Production Network
cd ../network
terraform destroy -auto-approve