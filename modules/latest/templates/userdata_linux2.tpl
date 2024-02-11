#!/bin/bash
# variable will be populated by terraform template
db_username=${db_username}
db_user_password=${db_user_password}
db_name=${db_name}
db_RDS=${db_RDS}
efs_volume_id=${efs_volume_id}
efs_mount_directory=${efs_mount_directory}

sudo yum update -y
sudo yum install docker -y
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum -y install amazon-efs-utils
sudo mkdir -p ${efs_mount_directory}
sudo mount -t efs -o tls ${efs_volume_id}:/ ${efs_mount_directory}
sudo docker run --name wordpress-docker \
    -e WORDPRESS_DB_USER=${db_username} \
    -e WORDPRESS_DB_HOST=${db_RDS} \
    -e WORDPRESS_DB_PASSWORD=${db_user_password} \
    -v ${efs_mount_directory}:${efs_mount_directory} \
    -p 80:80 -d wordpress:4.8-apache

