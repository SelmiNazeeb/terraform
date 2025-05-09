terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

variable "my_instance_type" {
    type = string
}

resource "aws_instance" "demo" {
    ami = "ami-0f88e80871fd81e91" 
    instance_type = var.my_instance_type
    tags = {
        Name = "${terraform.workspace}-demo"
        }
}