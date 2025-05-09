terraform {
    backend "s3" {
        bucket         = "selmins123"
        key            = "terraform.tfstate"
        region         = "us-east-1"
    }
}