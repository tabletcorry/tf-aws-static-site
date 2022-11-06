provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  default_tags {
    tags = local.tags
  }
}

provider "aws" {
  default_tags {
    tags = local.tags
  }
}