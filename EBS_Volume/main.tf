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

resource "aws_instance" "example" {
    ami = "ami-0953476d60561c955"
    instance_type = "t2.micro"
    tags ={
        Name = "example_instance"    
    }
    root_block_device {
      volume_size = 8
    } 
}

resource "aws_ebs_volume" "example_volume" {
    availability_zone = aws_instance.example.availability_zone
    size = 10
    type = "gp2"
    tags = {
        Name = "example-volume"
    }
}

resource "aws_volume_attachment" "example_attachment" {
    device_name = "/dev/sdf"
    volume_id = aws_ebs_volume.example_volume.id
    instance_id = aws_instance.example.id
    force_detach = true
}