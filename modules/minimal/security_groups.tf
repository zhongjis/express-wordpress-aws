# EC2 security group
resource "aws_security_group" "wp_ec2_sg" {
  name        = "wp_ec2_sg"
  description = "Allow web and SSH inbound traffic"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp_ec2_sg"
  }
}

# RDS security group
resource "aws_security_group" "wp_rds_sg" {
  name        = "wp_rds_sg"
  description = "Allow inbound traffic from EC2 instances to RDS"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wp_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp_rds_sg"
  }
}

# EFS security group
resource "aws_security_group" "wp_efs_sg" {
  name        = "wp_efs_sg"
  description = "Allow inbound NFS traffic from EC2 instances to EFS"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wp_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp_efs_sg"
  }
}

