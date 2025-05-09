variable "region_amis" {
  type = map(string)
  default = {
    "us-east-1" = "ami-0f88e80871fd81e91"
    "us-west-2" = "ami-085386e29e44dacd7"
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}
