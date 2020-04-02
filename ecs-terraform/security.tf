# security.tf

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "${var.ecs_service_name}-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = var.nginx_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx_task" {
  name        = "${var.ecs_service_name}-nginx-task-security-group"
  description = "allow inbound access to the NGINX task from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 0
    to_port         = var.nginx_port
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_task" {
  name        = "${var.ecs_service_name}-app-task-security-group"
  description = "allow inbound access to the Application task from NGINX"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = var.app_port
    cidr_blocks = [ aws_vpc.main.cidr_block ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
