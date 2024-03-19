# Terraform Deployment for Cloud Network Architecture

This Terraform project automates the deployment of a cloud network architecture consisting of multiple Virtual Private Clouds (VPCs), subnets, EC2 instances, and connectivity configurations. This README provides instructions for successfully deploying and cleaning up the architecture.
![Architecture Diagram](https://i.ibb.co/GFyp6DC/diagram.png)

Video Demontration: https://youtu.be/0VgxzO2o3Bw

## Prerequisites

Before deploying the infrastructure using Terraform, ensure the following pre-requisites are met:
- An AWS account with appropriate permissions to create VPCs, subnets, EC2 instances, and other necessary resources.
- Terraform installed on your local machine.
- An S3 bucket configured to store Terraform state. Make sure you have the necessary permissions to access this bucket.
  - create an S3 bucket named "kusal-assignment1" (or any other globally unique name you prefer. If you use different name, please make sure to update it on your config.tf files).
  - Additionally, create folders within the bucket to organize Terraform state files for different components of your infrastructure:
    - `dev/network/`
    - `dev/webservers/`
    - `prod/network/`
    - `prod/webservers/`
    - `vpc_peering/`


## Deployment Instructions

Follow these steps to deploy the cloud network architecture:
1. Clone this repository to your local machine:
    ```bash
    git clone https://github.com/KusalThiwanka/terraform_aws_cloud_architecture.git
    ```
2. Navigate to the cloned repository directory:
    ```bash
    cd terraform_aws_cloud_architecture
    ```

### Option 1: Automated Deployment using `deploy.sh`
  - Ensure the `deploy.sh` script has execution permissions. If not, grant them using:
    ```bash
      chmod +x deploy.sh
    ```
  - Run the script to automate the deployment process:
    ```bash
      ./deploy.sh
    ```

### Option 2: Manual Deployment:
1. Deploy Development Network:
    ```bash
    cd dev/network
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
2. Deploy Development Webservers
    ```bash
    cd ../webservers
    ssh-keygen -t rsa  -f devkeypair
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
3. Deploy Production Network
    ```bash
    cd ../../prod/network
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
4. Deploy Production Webservers
    ```bash
    cd ../webservers
    ssh-keygen -t rsa  -f prodkeypair
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
5. Deploy VPC Peering Connection
    ```bash
    cd ../../vpc_peering
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
6. Deploy Application Load Balancer
    ```bash
    cd ../alb
    terraform init
    terraform apply -auto-approve
    ```
    
    
## Destruction Instructions

To destroy the infrastructure and clean up all resources created, follow these steps:

### Option 1: Automated Destruction using `destroy.sh`:
  - Ensure the `destroy.sh` script has execution permissions. If not, grant them using:
    ```bash
      chmod +x destroy.sh
    ```
  - Run the script to automate the destruction process:
    ```bash
      ./destroy.sh
    ```

### Option 2: Manual Destruction:
1. Destroy resources in VPC Peering Connection
    ```bash
    cd ../vpc_peering
    terraform destroy -auto-approve
    ```
2. Destroy resources in Application Load Balancer
    ```bash
    cd ../alb
    terraform destroy -auto-approve
    ```
3. Destroy resources in Development Webservers
    ```bash
    cd ../dev/webservers
    terraform destroy -auto-approve
    ```
4. Destroy resources in Development Network
    ```bash
    cd ../network
    terraform destroy -auto-approve
    ```
5. Destroy resources in Production Webservers
    ```bash
    cd ../../prod/webservers
    terraform destroy -auto-approve
    ```
6. Destroy resources in Production Network
    ```bash
    cd ../network
    terraform destroy -auto-approve
    ```

After destroying all components, you can optionally delete the S3 bucket and its contents used for storing Terraform state.
