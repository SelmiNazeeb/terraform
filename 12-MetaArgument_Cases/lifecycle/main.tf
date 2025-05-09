terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

# Create ec2 instance 
resource "aws_instance" "terraform_ec2-1" {
    ami="ami-0f88e80871fd81e91"
    instance_type = "t2.micro"
    tags = { 
            Name = "terraform_ec2-1"
        }
    lifecycle {
        ignore_changes = [ tags ]
        #create_before_destroy = true     // true - Creates a new resource before destroying the old one
        prevent_destroy = false          // true - Prevents the resource from being destroyed
    }
}


 