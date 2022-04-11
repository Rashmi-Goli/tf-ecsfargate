terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}

############# create a security group that enables user to access the application #############
module "sec-group" {
  source = "./modules/sec-group"
  vpc_id = var.vpc_id
}

module "ecs" {
  source     = "./modules/ecs"
  subnet_id  = var.subnet_id
  secGroupID = module.sec-group.secGroupID
}

# module "s3bkt" {
#   source = "./modules/s3bkt"
#   bucket_name = var.bucket_name
# }

# module ecr{
#   source = "./modules/ecr"
#   region = var.region
#   image_id             = var.image_id
#   aws_account_id       = var.aws_account_id
#   repository-name      = var.repository-name
#   image_tag            = var.image_tag

# }