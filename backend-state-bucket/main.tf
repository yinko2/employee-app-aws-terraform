provider "aws" {
  region = "ap-southeast-1"
}

//Backend S3 bucket
resource "aws_s3_bucket" "backend_state" {
  bucket = "terraform-backend-state-amk-000"

  lifecycle {
    prevent_destroy = true
  }
}

// Bucket Versioning
resource "aws_s3_bucket_versioning" "backend_state_bucket_versioning" {
  bucket = aws_s3_bucket.backend_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

// Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "backend_state_bucket_encryption" {
  bucket = aws_s3_bucket.backend_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

//Locking - Dynamo DB
resource "aws_dynamodb_table" "backend_lock" {
  name         = "backend_state_terraform_locks"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}