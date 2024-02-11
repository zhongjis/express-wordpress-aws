# Create RDS Subnet group
resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = ["${aws_subnet.prod-subnet-private-1.id}", "${aws_subnet.prod-subnet-private-2.id}"]
}

# Create RDS instance
resource "aws_db_instance" "wordpressdb" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.instance_class
  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet_grp.id
  vpc_security_group_ids = ["${aws_security_group.RDS_allow_rule.id}"]
  db_name                = var.database_name
  username               = var.database_user
  password               = var.database_password
  skip_final_snapshot    = true

  # make sure rds manual password chnages is ignored
  lifecycle {
    ignore_changes = [password]
  }
}

locals {
  user_data = templatefile("${path.module}/${var.IsUbuntu ? "templates/userdata_ubuntu.tpl" : "templates/userdata_linux2.tpl"}", {
    db_username      = var.database_user
    db_user_password = var.database_password
    db_name          = var.database_name
    db_RDS           = aws_db_instance.wordpressdb.endpoint
  })
}

# Create EC2 ( only after RDS is provisioned)
resource "aws_instance" "wordpressec2" {
  ami                    = var.IsUbuntu ? data.aws_ami.ubuntu.id : data.aws_ami.linux2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod-subnet-public-1.id
  vpc_security_group_ids = ["${aws_security_group.ec2_allow_rule.id}"]
  user_data              = local.user_data
  key_name               = aws_key_pair.mykey-pair.id
  tags = {
    Name = "Wordpress.web"
  }

  root_block_device {
    volume_size = var.root_volume_size # in GB 

  }

  # this will stop creating EC2 before RDS is provisioned
  depends_on = [aws_db_instance.wordpressdb]
}

// Sends your public key to the instance
resource "aws_key_pair" "mykey-pair" {
  key_name   = "mykey-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}

# creating Elastic IP for EC2
resource "aws_eip" "eip" {
  instance = aws_instance.wordpressec2.id
}

resource "null_resource" "Wordpress_Installation_Waiting" {
  # trigger will create new null-resource if ec2 id or rds is chnaged
  triggers = {
    ec2_id       = aws_instance.wordpressec2.id,
    rds_endpoint = aws_db_instance.wordpressdb.endpoint
  }

  connection {
    type        = "ssh"
    user        = var.IsUbuntu ? "ubuntu" : "ec2-user"
    private_key = file(var.PRIV_KEY_PATH)
    host        = aws_eip.eip.public_ip
  }


  provisioner "remote-exec" {
    inline = ["sudo tail -f -n0 /var/log/cloud-init-output.log| grep -q 'WordPress Installed'"]
  }
}
