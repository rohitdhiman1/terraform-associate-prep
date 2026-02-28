# Main lab — uses S3 remote backend
# STEP 1: Run bootstrap/ first to create the bucket and DynamoDB table
# STEP 2: Fill in your bucket name below
# STEP 3: Run terraform init -migrate-state

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }

  # Uncomment and fill in after running bootstrap:
  # backend "s3" {
  #   bucket         = "REPLACE_WITH_YOUR_BUCKET_NAME"
  #   key            = "lab08/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = "us-east-1"
}

# Simple resource to manage — just something to put in state
resource "local_file" "example" {
  filename = "${path.module}/example.txt"
  content  = "This file's state is stored in S3!"
}

# AWS resource to verify real AWS access
resource "aws_s3_bucket" "lab_bucket" {
  bucket = "lab08-demo-${random_suffix()}"
}

# Use a random suffix
resource "aws_s3_object" "readme" {
  bucket  = aws_s3_bucket.lab_bucket.id
  key     = "README.txt"
  content = "Lab 08 demo object — state stored in remote S3 backend"
}

output "lab_bucket_name" {
  value = aws_s3_bucket.lab_bucket.bucket
}

output "state_location" {
  value = "State stored at: s3://BUCKET_NAME/lab08/terraform.tfstate"
}
