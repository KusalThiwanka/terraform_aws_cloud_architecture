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

# Variable to signal the current environment 
variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS Region"
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
  default     = "Assignment"
  type        = string
  description = "Name Prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# Variable for the github repository
variable "github_repo" {
  default     = "https://github.com/KusalThiwanka/samplehtml.git"
  type        = string
  description = "Github Repo Link"
}