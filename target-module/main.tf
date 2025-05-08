terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "ec2_module" {
    source = "./modules/ec2_module"
}

module "s3_module" {
    source = "./modules/s3_module"
}
