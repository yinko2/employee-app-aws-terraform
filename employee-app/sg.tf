# Security Group for HTTP
resource "aws_security_group" "employee_http_https_ssh" {
  name        = "web-security-group"
  description = "Created for Employee App http, https, ssh ingress"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "lb_sg" {
  name        = "load-balancer-sg"
  vpc_id      = aws_vpc.main.id
  description = "Load Balancer Security Group"
  egress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
}