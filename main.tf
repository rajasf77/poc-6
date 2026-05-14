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
#ECR Creation
resource "aws_ecr_repository" "my_app_warehouse" {
  name                 = "poc-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# 3. Create a Security Gate (Security Group)
# This is like a fence that only lets certain people in.
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_security_group"
  description = "Allow Jenkins traffic"

  # Opening Port 8080 (Jenkins' front door)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This lets YOU talk to Jenkins from home
  }

  # Opening Port 22 (The back door for maintenance)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Let the computer talk to the internet to download things
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. The Computer (EC2 Instance)
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0c7217cdde317cfec" # This is like picking "Windows" or "Linux"
  instance_type = "t2.medium"            # The size of the computer (Medium is good for Jenkins)
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Jenkins-Butler-Server"
  }
}
