provider "aws" {
  region                   = var.region
  shared_credentials_files = [var.aws_cli_credential]
  profile                  = "default"

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
    }
  }
}

