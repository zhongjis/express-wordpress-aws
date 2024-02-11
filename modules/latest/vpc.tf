# Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block           = var.VPC_cidr
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy     = "default"
}

# Create Public Subnet for EC2
resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = var.AZ1
}

# Create Private subnet for RDS
resource "aws_subnet" "prod-subnet-private-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.subnet2_cidr
  map_public_ip_on_launch = "false" //it makes private subnet
  availability_zone       = var.AZ2
}

# Create second Private subnet for RDS
resource "aws_subnet" "prod-subnet-private-2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.subnet3_cidr
  map_public_ip_on_launch = "false" //it makes private subnet
  availability_zone       = var.AZ3
}

# Create IGW for internet connection 
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
}
