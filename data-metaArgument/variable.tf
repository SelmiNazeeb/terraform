variable "vpc_cidr" {
    type = string
}

variable "pub_cidr" {
    type = string
}

variable "priv_cidr" {
    type = string
}

variable "az1" {
    type = string
}

variable "az2" {
    type = string
}

variable "my_instance_type" {
    type = string
}

variable "my_pub_instance_name" {
    type = string
}

variable "my_priv_instance_name" {
    type = string
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
  default     = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html
              EOF
}
