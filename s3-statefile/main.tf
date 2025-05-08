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

terraform {
    backend "s3" {
        bucket         = "selmins123"
        key            = "terraform/statefile.tfstate"
        region         = "us-east-1"
    }
}
resource "aws_instance" "tf_instance" {
    ami = "ami-0f88e80871fd81e91"
    instance_type = "t2.micro"
    tags = {
        Name = "Terraform-Instance"
    }
}