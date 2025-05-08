terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Use the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all public subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get latest Amazon Linux 2 AMI
# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

# Security Group to allow HTTP
resource "aws_security_group" "asg_sg" {
  name        = "asg-lb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

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
    Name = "asg-lb-sg"
  }
}

# Launch Template
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-template-"
  #image_id      = data.aws_ami.amazon_linux.id
  image_id      = var.my_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ASG-Instance"
    }
  }
}

# Target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Load Balancer
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.asg_sg.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Name = "web-alb"
  }
}

# Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = data.aws_subnets.default.ids
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "ASG-Web-Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
