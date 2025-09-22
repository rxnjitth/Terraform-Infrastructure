variable "ami" {
    description = "The AMI to use for the instance"
    type        = string
    default     = "ami-0abd2d0501963c350" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  
}

variable "instance_type" {
    description = "The type of instance to use"
    type        = string
    default     = "t2.micro"
  
}

variable "aws_security_group" {
    description = "The security group to associate with the instance"
    type        = string
    default     = "example-security-group" # Replace with your actual security group ID
  
}


locals {
    aws_security_group = aws_security_group.example_sg.name
}


  

variable "vpc_id" {
  description = "VPC ID for security group creation"
  type        = string
  default = ""
  
  
}

variable "subnet_id" {
  description = "ID of subnet to launch the instance in"
  type        = string
  default = ""
}