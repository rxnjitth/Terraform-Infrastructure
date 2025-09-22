variable "terraform" {
  description = "Name of the project used for tagging resources"
  type        = string
  default     = "terra"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_a" {
  description = "Availability Zone for the public subnet"
  type        = string
  default     = "ap-southeast-1a"
}

variable "availability_zone_b" {
  description = "Availability Zone for the private subnet"
  type        = string
  default     = "ap-southeast-1b"
}