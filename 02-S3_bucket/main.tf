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

# Create an S3 bucket
resource "aws_s3_bucket" "sample_bucket" {
    bucket = "selmi123"
    tags = {
        Name = "selmi123"
        Environment = "dev"
    }
}
