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

# Create ec2 instance
resource "aws_instance" "terraform_ec2-1" {
  ami="ami-0e449927258d45bc4"
  instance_type = "t2.micro"
 
}
