# Terraform AWS Infrastructure

A simple, modular Terraform project that deploys AWS resources including VPC, EC2 instances, and S3 storage with proper connectivity.

## What It Does

- Creates a VPC with public/private subnets
- Deploys EC2 instances in the VPC
- Sets up security groups for networking


## Quick Start

```bash
# Initialize Terraform
terraform init

# Deploy resources
terraform apply

# Clean up when done
terraform destroy
```

## Module Structure

- `modules/vpc` - Network infrastructure
- `modules/ec2_instance` - Compute resources

## Usage Example

```terraform
# Create basic infrastructure
module "vpc" {
  source = "./modules/vpc"
}

module "ec2_instance" {
  source    = "./modules/ec2_instance"
  subnet_id = module.vpc.public_subnet_id
  vpc_id    = module.vpc.vpc_id
}
```

## Author

rxnjitth