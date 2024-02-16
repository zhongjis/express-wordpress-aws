// MYSQL RDS setup
resource "random_password" "wp_db_user_password" {
  length           = 16
  special          = true
  override_special = "_%@"
  keepers = {
    version = "1" // update this value to regenerate password
  }
}

resource "aws_db_subnet_group" "wp_db_subnet_group" {
  name       = "wp_db_subnet_group"
  subnet_ids = [aws_subnet.wp_private_subnet_1.id, aws_subnet.wp_private_subnet_2.id]

  tags = {
    Name = "wp_db_subnet_group"
  }
}

resource "aws_db_instance" "wp_db" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.rds_instance_type
  db_name                = var.wp_db_name
  username               = var.wp_db_user
  password               = random_password.wp_db_user_password.result
  db_subnet_group_name   = aws_db_subnet_group.wp_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.wp_rds_sg.id]
  skip_final_snapshot    = true

  tags = {
    Name = "wp_db"
  }
}

// EC2 setup
resource "aws_key_pair" "wp_ec2_pub_key" {
  key_name   = "wp_ec2_key_pair"
  public_key = file(var.ec2_public_key_path)
}

locals {
  user_data = templatefile(
    "${path.module}/templates/userdata_linux2.tpl",
    {
      db_endpoint      = aws_db_instance.wp_db.endpoint
      db_name          = aws_db_instance.wp_db.db_name
      db_user          = aws_db_instance.wp_db.username
      db_user_password = aws_db_instance.wp_db.password
      efs_volume_id    = aws_efs_file_system.wp_efs.id
  })

  depends_on = [aws_db_instance.wp_db]
}

resource "aws_instance" "wp_instance" {
  ami                    = data.aws_ami.linux2.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.wp_ec2_pub_key.id
  subnet_id              = aws_subnet.wp_public_subnet.id
  vpc_security_group_ids = [aws_security_group.wp_ec2_sg.id]
  user_data              = local.user_data

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "wp_instance"
  }

  depends_on = [aws_db_instance.wp_db]
}

// EFS setup
resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wp_efs"

  tags = {
    Name = "wp_efs"
  }
}

resource "aws_efs_mount_target" "wp_efs_mt" {
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = aws_subnet.wp_public_subnet.id
  security_groups = [aws_security_group.wp_efs_sg.id]
}
