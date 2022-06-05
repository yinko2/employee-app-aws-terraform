resource "aws_s3_bucket" "employee_photo" {
  bucket = "employee-photo-bucket-amk-001"
}

resource "aws_s3_bucket_policy" "allow_access_for_employee_photo" {
  bucket = aws_s3_bucket.employee_photo.id
  policy = jsonencode(
    {
      Statement = [
        {
          Action = "s3:*"
          Effect = "Allow"
          Principal = {
            AWS = aws_iam_role.instance_role.arn
          }
          Resource = [
            aws_s3_bucket.employee_photo.arn,
            "${aws_s3_bucket.employee_photo.arn}/*",
          ]
          Sid = "AllowS3ReadAccess"
        },
      ]
      Version = "2012-10-17"
    }
  )
}