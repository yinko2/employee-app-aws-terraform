resource "aws_iam_role" "instance_role" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  description = "Allows EC2 instances to call AWS services on your behalf."
  managed_policy_arns = [
    data.aws_iam_policy.aws_dynamodb_full_access.arn,
    data.aws_iam_policy.aws_s3_full_access.arn,
  ]
  name = "S3DynamoDBFullAccessRole"
}

# Instance Profile for ECS Instance
resource "aws_iam_instance_profile" "instance_profile" {
  name = "S3DynamoDBFullAccessRole"
  role = aws_iam_role.instance_role.name
}

# AutoScaling Role for ECS
resource "aws_iam_role" "autoscaling_role" {
  name        = "AWSServiceRoleForAutoScaling"
  description = "Default Service-Linked Role enables access to AWS Services and Resources used or managed by Auto Scaling"
  path        = "/aws-service-role/autoscaling.amazonaws.com/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = [data.aws_iam_policy.aws_autoscaling_policy.arn]
}