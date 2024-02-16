output "wp_db_endpoint" {
  value = module.minimal.wp_db_endpoint
}

output "wp_db_user" {
  value = module.minimal.wp_db_user
}

output "wp_db_user_password" {
  value     = module.minimal.wp_db_user_password
  sensitive = true
}

output "wp_ec2_instance_dns" {
  value = module.minimal.wp_ec2_instance_dns
}
