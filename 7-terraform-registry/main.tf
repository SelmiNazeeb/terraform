terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

module "ec2-instance" {
  source           = "terraform-aws-modules/ec2-instance/aws"
  version          = "5.8.0"
}

