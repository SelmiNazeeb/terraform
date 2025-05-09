terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = var.region_amis[var.region]
  instance_type = "t2.micro"
}

#output
output "ec2_instance_ami" {
  value = aws_instance.example.ami
}

output "aws_region" {
  value = var.region
}
