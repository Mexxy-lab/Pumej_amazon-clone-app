# VPC, subnets, IGW, NAT Gateway - All Network requirements 

resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "main_vpc" }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = { Name = "vpc_igw" }
}

resource "aws_subnet" "eks_pub_sub_one" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = { Name = "Pub Subnet One" }
}

resource "aws_subnet" "eks_pub_sub_two" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = { Name = "Pub Subnet two" }
}

resource "aws_subnet" "eks_priv_sub_one" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2a"
  tags = { Name = "Private Subnet one" }
}

resource "aws_subnet" "eks_priv_sub_two" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-2b"
  tags = { Name = "Private Subnet two" }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "eks_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.eks_pub_sub_one.id
  depends_on    = [aws_internet_gateway.eks_igw]
  tags = { Name = "Natty GW" }
}
