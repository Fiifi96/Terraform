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

# 1. Create a new VPC

resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"  ## default is instance shared with other AWS users on one hardware/Server

  tags = {
    Name = "test-vpc"
  }
}

# 2. Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test-gw"
  }
}

# 3. Create Custom Route Table

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route_table"
  }
}


# 4. Create Subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet-1"
  }
} 

# 5. Associte subnet with route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route_table.id
}

# 6. Create Security Group for SSH, HTTP and HTTPS

resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description      = "Traffic from VPC(HTTPS)"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Traffic from VPC(HTTP)"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Traffic from VPC(SSH)"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
  
}

# 7. Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "test-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web_traffic.id]

}

# 8. Assign an elastic Ip to the network interface created in step 7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test-nic.id
  associate_with_private_ip = "10.0.1.50"
  
}

#9. Create a Amazon Linux 2 server
resource "aws_instance" "web-test" {
  ami           = "ami-08b6f2a5c291246a0"
  instance_type = "t2.micro"
  # availability_zone = "us-east-1"
  # key_name = "bkey"

  tags = {
    Name = var.instance_name
  }
}

# 10. Install and create apache2 web server











# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.27"
#     }
#   }

#   required_version = ">= 0.14.9"
# }

# provider "aws" {
#   profile = "default"
#   region  = "us-east-2"
#   access_key = "AKIA2T7WVBKXXKFDHOIL"
#   secret_key = "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"
# }

# resource "aws_vpc" "test-vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "test-vpc"
#   }
# }

# resource "aws_subnet" "subnet-1" {
#   vpc_id = aws_vpc.test-vpc.id       ## vpc not created yet so vpc_id can't be obtained. So this command is used to get the vpc_id
#   cidr_block = "10.0.1.0/24"

#   tags ={
#     Name = "test-subnet-1"
#   }
# }

# resource "aws_instance" "app_server" {
#   ami           = "ami-0b614a5d911900a9b"
#   instance_type = "t2.micro"

#   tags = {
#     Name = var.instance_name
#   }
# }

terraform {
  cloud {
    organization = "BSAM"

    workspaces {
      name = "Project-1"
    }
  }
}

