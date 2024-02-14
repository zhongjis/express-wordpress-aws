provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"

  default_tags {
    tags = {
      Project   = "express-prototype"
      ManagedBy = "Terraform"
    }
  }
}

