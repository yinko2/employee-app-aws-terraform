# Get the AWS Managed Policy "AmazonS3FullAccess"
data "aws_iam_policy" "aws_s3_full_access" {
  name = "AmazonS3FullAccess"
}

# Get the AWS Managed Policy "AmazonDynamoDBFullAccess"
data "aws_iam_policy" "aws_dynamodb_full_access" {
  name = "AmazonDynamoDBFullAccess"
}

# Get the AWS Managed Policy "AutoScalingServiceRolePolicy"
data "aws_iam_policy" "aws_autoscaling_policy" {
  name = "AutoScalingServiceRolePolicy"
}

# Get the Latest Amazon Linux AMI
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}