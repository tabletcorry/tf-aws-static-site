provider "aws" {}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "net-corryh-terraform"
    key    = "website/core.tf"
    region = "us-west-2"
  }
}