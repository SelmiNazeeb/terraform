#create s3 bucket 1
resource "aws_s3_bucket" "selmi123-1" {
    bucket = "selmi123-1"
    tags = {
        Name = "selmi123-1"
        Environment = "dev"
    }
}

#create s3 bucket 2
resource "aws_s3_bucket" "selmi123-2" {
    bucket = "selmi123-2"
    tags = {
        Name = "selmi123-2"
        Environment = "dev"
    }
}