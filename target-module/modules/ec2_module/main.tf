# Create ec2 instance 1
resource "aws_instance" "terraform_ec2-1" {
  ami="ami-0e449927258d45bc4"
  instance_type = "t2.micro"
  tags = { 
        Name = "terraform_ec2-1"
    }
}

# Create ec2 instance 2
resource "aws_instance" "terraform_ec2-2" {
  ami="ami-0e449927258d45bc4"
  instance_type = "t2.micro"
  tags = { 
        Name = "terraform_ec2-2"
    }
}
