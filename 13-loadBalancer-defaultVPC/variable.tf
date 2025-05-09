variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default = "t2.micro"
}

variable "my_ami" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0f88e80871fd81e91"
}

variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
  default    = "us-east-1"
}

