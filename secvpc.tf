// AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "vpc"
  }
}



resource "aws_subnet" "pubsubnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pubcidr
  availability_zone = var.az1
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "privsubnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.privcidr
  availability_zone = var.az1
  tags = {
    Name = "Privsubnet"
  }
}
