module "minimal" {
  source = "./modules/minimal"

  project_name = "easycheezy.shop"

  region             = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr_block     = "10.0.0.0/16"
  subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  ec2_public_key_path  = "~/.ssh/aws.pub" // key name for ec2, make sure it is created before terrafomr apply
  ec2_private_key_path = "~/.ssh/aws"
}
