// Store Terraform Backend State on S3 Bucket
terraform {
  backend "s3" {
    bucket         = "terraform-backend-state-amk-000"
    key            = "employee-app/backend-state"
    region         = "ap-southeast-1"
    dynamodb_table = "backend_state_terraform_locks"
    encrypt        = true
  }
}

// Define Provider and Region
provider "aws" {
  region = var.region
}