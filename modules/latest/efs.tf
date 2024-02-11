// TODO: need efs setup here
resource "aws_efs_file_system" "efs_volume" {
  creation_token = "efs_volume"
}

resource "aws_efs_mount_target" "efs_mount_target_1" {
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.prod-subnet-public-1.id
  security_groups = [aws_security_group.efs_sg.id]
}
