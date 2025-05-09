
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

#Scenario 1:Real-Time Scenario: Deploying Infrastructure in Dev, Staging, and Prod

variable "instance_type" {
  type = string
  default = "t2.micro"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0e449927258d45bc4"  
  instance_type = var.instance_type
  tags = {
    Name = terraform.workspace
  }
}

# Scenario 2:Provisioning S3 Buckets for Dev, Staging, and Prod
# resource "aws_s3_bucket" "logs" {
#   bucket = "logs-${terraform.workspace}-bucket"

# }

terraform {
    backend "s3" {
        bucket         = "selmins123"
        key            = "terraform.tfstate"
        region         = "us-east-1"
    }
}

#scenario 3: VPC per Environment (dev, staging, prod)

resource "aws_vpc" "main" {
  cidr_block = "10.${terraform.workspace == "prod" ? 0 : terraform.workspace == "staging" ? 1 : 2}.0.0/16"
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

#Scenarios 4: RDS per Environment with Different Sizes
resource "aws_db_instance" "db" {
  identifier        = "app-db-${terraform.workspace}"
  instance_class    = terraform.workspace == "prod" ? "db.t3.large" : "db.t3.micro"
  allocated_storage = terraform.workspace == "prod" ? 100 : 20
  engine            = "mysql"
  username          = "admin"
  password          = "admin123"
  skip_final_snapshot = true
}