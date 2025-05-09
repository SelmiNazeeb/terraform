terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

variable "instance_name" {
    default = "demo-instance" 
}

provider "aws" {
    region = "us-east-1"
}

# #case1
variable "create_instance" {
    description = "flag to control instance creation"
    type = bool
    default = true
}

resource "aws_instance" "instance-1" {
    count = var.create_instance ? 1 : 0
    ami = "ami-0f88e80871fd81e91"
    instance_type = "t2.micro"
    tags = {
        Name = "condition-1"
    }
}

#case2
variable "my_environment" {
    description = "environment name"
    type = string
    default = "dev"
}

resource "aws_instance" "instance-2" {
    ami ="ami-0f88e80871fd81e91"
    instance_type = var.my_environment == "dev" ? "t2.micro" : "t3.micro"
    tags = {
        Name = "instance-$(var.my_enironment)"
    }
}

# #case3
resource "aws_instance" "instance-3" {
    count = (var.create_instance && var.my_environment == "prod") ? 1 :0
    ami = "ami-0f88e80871fd81e91"
    instance_type = "t2.micro"
    tags ={
        Name = "condition-$(var.my_environment)"
    }
}

# #case4
locals {
    instance_type = (var.my_environment == "prod" ? "t2.micro" : 
                     var.my_environment == "staging" ? "t3.micro" : "t3.medium")
}

resource "aws_instance" "instance-4" {
    ami = "ami-0f88e80871fd81e91"
    instance_type = local.instance_type
    tags = {
        Name = "condition-$(var.my_environment)"
    }
}

# #case5
resource "aws_instance" "instance-5" {
    count = (var.create_instance && (var.my_environment == "prod" || var.my_environment == "dev")) ? 1 : 0 
    ami = "ami-0f88e80871fd81e91"
    instance_type = "t2.micro"
    tags = {
        Name = "condition-$(var.my_environment)"
    }
}

 