terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
  access_key = "AKIA2T7WVBKXXKFDHOIL"
  secret_key = "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"
}

resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.test-vpc.id       ## vpc not created yet so vpc_id can't be obtained. So this command is used to get the vpc_id
  cidr_block = "10.0.1.0/24"

  tags ={
    Name = "test-subnet-1"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b614a5d911900a9b"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

terraform {
  cloud {
    organization = "BSAM"

    workspaces {
      name = "Project-1"
    }
  }
}

