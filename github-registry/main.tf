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
  source           = "git::https://github.com/SelmiNazeeb/terraform-aws-ec2-instance.git?ref=v1.0.0"
}
