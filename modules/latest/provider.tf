provider "aws" {
  region                   = var.region
  shared_credentials_files = [var.shared_credentials_file]
  profile                  = "default"

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
    }
  }
}

