provider "aws" {
  region = var.region
}

provider "archive" {
}

data "aws_caller_identity" "current" {
}