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

module "ec2_module" {
    source = "./modules/ec2-module"
    my_ami_id = var.my_ami_id_input
    my_instance_type = var.my_instance_type_input
}
module s3_module {
    source = "./modules/s3_module"
    my_bucket_name = var.my_bucket_name_input
}
