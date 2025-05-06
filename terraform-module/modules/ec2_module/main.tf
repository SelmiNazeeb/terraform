resource "aws_instance" "sample_ec2" {
    ami = var.my_ami_id
    instance_type = var.my_instance_type
 
}
