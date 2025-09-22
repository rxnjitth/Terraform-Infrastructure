module "vpc" {
  source        = "./modules/vpc"
  
  
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  subnet_id = module.vpc.public_subnet_id
  vpc_id = module.vpc.vpc_id

  
}