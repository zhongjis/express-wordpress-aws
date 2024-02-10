# Base image with basic tooling
FROM ubuntu:22.04

# Update packages 
RUN apt-get update && apt-get install -y curl unzip

# Download and install Terraform 1.1.3
RUN curl -s https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip \
    -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/

# Set working directory inside the container
WORKDIR /app

# Optional: Add a non-root user for security (replace 'your_user')
RUN useradd -ms /bin/bash zshen
USER zshen
