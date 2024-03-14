# Name prefix
variable "prefix" {
  default     = "assignment1"
  type        = string
  description = "Name Prefix"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}