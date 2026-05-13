terraform {
  backend "s3" {
    bucket = "terraform-rajjaaa77"
    key    = "state/terraform.tfstate"
    region = "eu-north-1"
  }
provider "aws" {
  region = "us-east-1" 
}

resource "aws_ecr_repository" "my_app_warehouse" {
  name                 = "poc-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
