#!/bin/bash
# variable will be populated by terraform template
db_endpoint=${db_endpoint}
db_name=${db_name}
db_user=${db_user}
db_user_password=${db_user_password}
efs_volume_id=${efs_volume_id}

sudo yum update -y
sudo yum install docker -y
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum -y install amazon-efs-utils
sudo mkdir -p /mnt/efs
sudo mount -t efs -o tls ${efs_volume_id}:/ /mnt/efs
sudo docker run --name wordpress-docker \
    -restart=always \
    -e WORDPRESS_DB_HOST=${db_endpoint} \
    -e WORDPRESS_DB_NAME=${db_name} \
    -e WORDPRESS_DB_USER=${db_user} \
    -e WORDPRESS_DB_PASSWORD=${db_user_password} \
    -v /mnt/efs:/var/www/html \
    -p 80:80 -d wordpress:6.4-apache
