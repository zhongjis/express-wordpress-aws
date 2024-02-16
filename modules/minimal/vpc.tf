# Create VPC
resource "aws_vpc" "wp_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "wp_vpc"
  }
}

# Create Subnets
resource "aws_subnet" "wp_public_subnet" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = var.subnet_cidr_blocks[0]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]

  tags = {
    Name = "wp_public_subnet"
  }
}

resource "aws_subnet" "wp_private_subnet_1" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = var.subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "wp_private_subnet"
  }
}

resource "aws_subnet" "wp_private_subnet_2" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = var.subnet_cidr_blocks[2]
  availability_zone = var.availability_zones[1]
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
