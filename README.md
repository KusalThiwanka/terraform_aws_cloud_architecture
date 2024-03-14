# Terraform Deployment for Cloud Network Architecture

This Terraform project automates the deployment of a cloud network architecture consisting of multiple Virtual Private Clouds (VPCs), subnets, EC2 instances, and connectivity configurations. This README provides instructions for successfully deploying and cleaning up the architecture.
![Architecture Diagram](https://i.ibb.co/GFyp6DC/diagram.png)

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
3. Deploy development VPC network:
    ```bash
    cd dev/network
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
4. Deploy development webserver:
    ```bash
    cd ../webservers
    ssh-keygen -t rsa  -f devkeypair
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
5. Deploy the production network:
    ```bash
    cd ../../prod/network
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
6. Deploy production webserver:
    ```bash
    cd ../webservers
    ssh-keygen -t rsa  -f prodkeypair
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
7. Run VPC peering connection:

    ```bash
    cd ../../vpc_peering
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
    
    
## Destruction Instructions

To destroy the infrastructure and clean up all resources created, follow these steps:
1. Navigate to each component directory and run Terraform destroy command:

    ```bash
    cd vpc_peering
    terraform destroy -auto-approve
    cd ../dev/webservers
    terraform destroy -auto-approve
    cd ../network
    terraform destroy -auto-approve
    cd ../../prod/webservers
    terraform destroy -auto-approve
    cd ../network
    terraform destroy -auto-approve
    ```

2. After destroying all components, you can optionally delete the S3 bucket and its contents used for storing Terraform state.
