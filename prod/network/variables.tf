variable "profile" {
  default     = "default"
  type        = string
  description = "AWS Profile"
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS Region"
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.10.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  default     = []
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_subnet_cidrs" {
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# Name prefix
variable "prefix" {
  default     = "assignment1"
  type        = string
  description = "Name Prefix"
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Kusal Thiwanka",
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}