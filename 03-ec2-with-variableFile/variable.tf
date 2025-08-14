# Define variables
variable "my_ami_id" {
    type = string
}
variable "my_instance_type" {
    type = string
}

variable "my_region" {
    type = string
}

variable "my_ec2" {
    type = string
}


############################################
###without tfvars
variable "my-ami" {
  type = string
  default = "ami-0f88e80871fd81e91"
}
variable "my-instance-type" {
  type = string
  default = "t2.micro"
}
