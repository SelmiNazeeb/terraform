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
    region = var.my_region
}

# Create an EC2 instance
resource "aws_instance" "sample_ec2" {
    ami = var.my_ami_id
    instance_type = var.my_instance_type
    tags = {
        Name = "var.my_ec2"
    }
}

