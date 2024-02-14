# Create VPC
resource "aws_vpc" "wp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "wp_vpc"
  }
}

# Create Subnets
resource "aws_subnet" "wp_public_subnet" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "wp_public_subnet"
  }
}

resource "aws_subnet" "wp_private_subnet_1" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "wp_private_subnet"
  }
}

resource "aws_subnet" "wp_private_subnet_2" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "wp_private_subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    Name = "wp_igw"
  }
}

# Create Route Table
resource "aws_route_table" "wp_route_table" {
  vpc_id = aws_vpc.wp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp_igw.id
  }

  tags = {
    Name = "wp_route_table"
  }
}

resource "aws_route_table_association" "wp_a" {
  subnet_id      = aws_subnet.wp_public_subnet.id
  route_table_id = aws_route_table.wp_route_table.id
}
