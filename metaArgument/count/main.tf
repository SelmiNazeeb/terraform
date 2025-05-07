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

resource "aws_instance" "server" {
  count = 2 # create two similar EC2 instances

  ami = "ami-0f88e80871fd81e91"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}