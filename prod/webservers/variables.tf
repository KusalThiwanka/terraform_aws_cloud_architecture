variable "profile" {
  default     = "default"
  type        = string
  description = "AWS Profile"
}

# Variable to signal the current environment 
variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS Region"
}

# Instance type
variable "instance_type" {
  default = {
    "prod" = "t2.micro"
    "test" = "t2.micro"
    "dev"  = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Kusal Thiwanka"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  default     = "Assignment1"
  type        = string
  description = "Name Prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}