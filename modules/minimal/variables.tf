variable "project_name" {
  description = "The name of the project, all resources will have a tag of this."
  type        = string
}

variable "aws_cli_credential" {
  type    = string
  default = "~/.aws/credentials"
}

variable "wp_db_name" {
  type    = string
  default = "wordpress_db"
}

variable "wp_db_user" {
  type    = string
  default = "wordpress_user"
}

variable "region" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_cidr_block" {
  type = string
}

variable "subnet_cidr_blocks" {
  type = list(string)
}

variable "ec2_public_key_path" {
  type = string
}

variable "ec2_private_key_path" {
  type = string
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "rds_instance_type" {
  type    = string
  default = "db.t2.micro"
}
