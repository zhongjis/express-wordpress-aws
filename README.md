# express-wordpress-aws

**This terraform projects creates a WordPress site using AWS resources**

It aims to provide seemless experience for small business to deploy their wordpress site using terraform.

---

AWS FREE TRIAL friendly

---

#

My goal is creating a simple, minimal wordpress site using terraform.

Simply put the workflow is (assume you have `tf` and `awscli` set up):

- Set up / prepare the vars.
- `terraform init`, then `terraform apply`
- Done. You have your wordpress site running with minimal cost & effort

Target audience of this repo currently is only for small business (< 1k daily visits).

# First Release (before 2024-03-01) - minimal (completed)

- [x] wordpress userdata is currently broken. the site is not working. I am working on it.
- [x] use `random` terrform provider to generate random password for RDS

# Second Release (before 2024-03-15) - minimal polished

- [ ] add custom domain setup
- [ ] add SSL setup (support https)

# Later Releases

- [ ] add bitmore setup
- [ ] figure out how wordpress
- [ ] s3 storage for terraform state
- [ ] consider adding autoscaling group for EC2
- [ ] add tech stack info to readme.md
- [ ] more to readme.md

# Tech Stack

- EC2: AWS Linux 2
- RDS: MySQL 8.0
- EFS: for wordpress files

# How to deploy

1. assume you already have access token setup (easiest way is `aws configure`)
2. `terraform init` under the module you would like to deploy
3. `terraform apply`

This repo was originally forked from https://github.com/devbhusal/terraform-ec2-RDS-wordpress
