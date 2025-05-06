resource "aws_s3_bucket" "sample_bucket" {
    bucket = var.my_bucket_name
    tags = {
        Name = var.my_bucket_name
        Environment = "dev"
    }
}
