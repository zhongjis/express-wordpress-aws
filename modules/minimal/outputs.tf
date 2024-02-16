output "wp_db_endpoint" {
  value = aws_db_instance.wp_db.endpoint
}

output "wp_db_user" {
  value = aws_db_instance.wp_db.username
}

output "wp_db_user_password" {
  value     = aws_db_instance.wp_db.password
  sensitive = true
}

output "wp_ec2_instance_dns" {
  value = aws_instance.wp_instance.public_dns
}
