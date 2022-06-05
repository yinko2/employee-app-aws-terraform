output "elb_endpoint" {
  value = aws_lb.employee_app_lb.dns_name
}