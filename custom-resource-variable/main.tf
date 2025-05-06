#create vpc,subnet,route table, internet gateway, nat gateway, security group, ec2 instance,nacl
#create by using variable file

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

# Create a VPC with a CIDR block 
resource "aws_vpc" "UST-B-VPC" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "UST-B-VPC-tag"
    }
}

# Create a internet gateway
resource "aws_internet_gateway" "UST-B-IGTW" {
    vpc_id = aws_vpc.UST-B-VPC.id
    tags = {
        Name = "UST-B-IGTW-tag"
    }  
}

# Create public subnet
resource "aws_subnet" "UST-B-PubSub" {
    vpc_id = aws_vpc.UST-B-VPC.id
    cidr_block = var.pub_cidr
    availability_zone = var.az1
    tags = {
        Name = "UST-A-PrivSub"
    }
}

# Create private subnet
resource "aws_subnet" "UST-B-PrivSub" {
    vpc_id = aws_vpc.UST-B-VPC.id
    cidr_block = var.priv_cidr
    availability_zone = var.az2
    tags = {
        Name = "UST-B-PrivSub"
    }
}

# create public route table
resource "aws_route_table" "UST-B-PubRT" {
    vpc_id = aws_vpc.UST-B-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.UST-B-IGTW.id
    }
    tags = {
        Name = "UST-B-PubRT-tag"
    }
}

# Create a private route table
resource "aws_route_table" "UST-B-PrivRT" {
    vpc_id = aws_vpc.UST-B-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.UST-B-NATGW.id
    }
    tags = {
        Name = "UST-B-PrivRT-tag"
    }
}

# create public route table association
resource "aws_route_table_association" "UST-B-PubRT-Assoc" {
    subnet_id      = aws_subnet.UST-B-PubSub.id
    route_table_id = aws_route_table.UST-B-PubRT.id
}

# create private route table association
resource "aws_route_table_association" "UST-B-PrivRT-Assoc" {
    subnet_id = aws_subnet.UST-B-PrivSub.id
    route_table_id = aws_route_table.UST-B-PrivRT.id
}

#create a elastic ip
resource "aws_eip" "UST-B-ElasticIP" {
    domain = "vpc"
    tags = {
        Name = "UST-B-ElasticIP-tag"
    }
}

#create a NAT gateway
resource "aws_nat_gateway" "UST-B-NATGW" {
    allocation_id = aws_eip.UST-B-ElasticIP.id
    subnet_id     = aws_subnet.UST-B-PubSub.id
    tags = {
        Name = "UST-B-NATGW-tag"
    }
}

#create a security group
resource "aws_security_group" "UST-B-SG" {
    name       = "UST-B-SG"
    description = "Security group for UST-B"
    vpc_id = aws_vpc.UST-B-VPC.id
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "UST-B-SG"
    }
}

#create NACL
resource "aws_network_acl" "UST-B-NACL" {
    vpc_id = aws_vpc.UST-B-VPC.id
    ingress {
        rule_no    = 100
        protocol   = "-1"
        from_port  = 0
        to_port    = 0
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        }
    egress {
        rule_no    = 100
        protocol   = "-1"
        from_port  = 0
        to_port    = 0
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        }  
}

# Create a NACL association for public subnet
resource "aws_network_acl_association" "UST-B-NACL-Assoc" {
    subnet_id = aws_subnet.UST-B-PubSub.id
    network_acl_id = aws_network_acl.UST-B-NACL.id 
}

# Create a NACL association for private subnet
resource "aws_network_acl_association" "UST-B-NACL-Assoc-Priv" {
    subnet_id = aws_subnet.UST-B-PrivSub.id
    network_acl_id = aws_network_acl.UST-B-NACL.id
}

# Ec2 Public instance
resource "aws_instance" "UST-B-Pub-Instance" {
    ami = var.my_ami
    instance_type = var.my_instance_type
    subnet_id = aws_subnet.UST-B-PubSub.id
    vpc_security_group_ids = [aws_security_group.UST-B-SG.id]
    associate_public_ip_address = true
    tags = {
        Name = var.my_pub_instance_name
    }
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo "<h1>Hello from UST-B-Pub-Instance</h1>" > /var/www/html/index.html
    EOF
  
}

# Ec2 Private instance
resource "aws_instance" "UST-B-Priv-Instance" {
    ami = var.my_ami
    instance_type = var.my_instance_type
    subnet_id = aws_subnet.UST-B-PrivSub.id
    vpc_security_group_ids = [aws_security_group.UST-B-SG.id]
    tags = {
        Name = "UST-B-Priv-Instance"
    }
    user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo "<h1>Hello from UST-A-Priv-Instance</h1>" > /var/www/html/index.html
    EOF
  
}

output "public_ec2_public_ip" {
  value = aws_instance.UST-B-Pub-Instance.public_ip
}


