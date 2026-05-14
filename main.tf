terraform {
  backend "s3" {
    bucket = "terraform-rajjaaa77"
    key    = "state/terraform.tfstate"
    region = "eu-north-1"
  } 
}   

provider "aws" {
  region = "us-east-1" 
}

# 1. The Warehouse (ECR)
resource "aws_ecr_repository" "my_app_warehouse" {
  name                 = "poc-app-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# 2. The Fence (Security Group)
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_security_group"
  description = "Allow Jenkins traffic"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. The Free Tier Computer (EC2)
resource "aws_instance" "jenkins_server" {
  # Standard Amazon Linux 2023 AMI for us-east-1
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = "t2.micro" # <--- CHANGED THIS TO STAY FREE
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Jenkins-Butler-Server"
  }
}
