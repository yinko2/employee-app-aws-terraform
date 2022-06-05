# Auto Scaling Group
resource "aws_autoscaling_group" "employee_app_asg" {
  desired_capacity        = 2
  health_check_type       = "ELB"
  max_size                = 4
  min_size                = 2
  name                    = "app-asg"
  service_linked_role_arn = aws_iam_role.autoscaling_role.arn
  target_group_arns = [
    aws_lb_target_group.employee_app_lb_tg.arn
  ]
  vpc_zone_identifier = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.employee_asg_lt.id
    version = "$Latest"
  }
}

# Launch Template for ASG
resource "aws_launch_template" "employee_asg_lt" {
  image_id      = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type = "t2.micro"
  key_name      = aws_key_pair.employee_app.key_name
  name          = "app-launch-template"
  vpc_security_group_ids = [
    aws_security_group.employee_http_https_ssh.id
  ]

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile.arn
  }

  update_default_version = true

  user_data = base64encode(format(<<-EOT
    #!/bin/bash -ex
    wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
    unzip FlaskApp.zip
    cd FlaskApp/
    yum -y install python3 mysql
    pip3 install -r requirements.txt
    amazon-linux-extras install epel
    yum -y install stress
    export PHOTOS_BUCKET=${aws_s3_bucket.employee_photo.bucket}
    export AWS_DEFAULT_REGION=${var.region}
    export DYNAMO_MODE=on
    FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
    EOT
  ))
}

# Auto Scaling Policy
resource "aws_autoscaling_policy" "employee_asg_scaling_policy" {
  autoscaling_group_name    = aws_autoscaling_group.employee_app_asg.name
  name                      = "CPU-Utilization-Policy"
  estimated_instance_warmup = 300
  policy_type               = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = 60
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}

resource "aws_key_pair" "employee_app" {
  key_name   = "employee-app"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "employee-app.pem"
}