resource "aws_instance" "public" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.public1.id
    key_name      = var.key_pair
    vpc_security_group_ids = [ aws_security_group.ec2-public-sg.id ]
    depends_on = [ aws_vpc.example, aws_internet_gateway.igw ]
    associate_public_ip_address = true

    tags = {
        Name = "${var.project_name}-ec2-public"
    }

    user_data = file("docker_install.sh")
}

resource "aws_security_group" "ec2-public-sg" {
    name        = "${var.project_name}-public-sg"
    description = "allow inbound access to the EC2 instance"
    vpc_id      = aws_vpc.example.id

    ingress {
        description = "SSH"
        protocol    = "TCP"
        from_port   = 22
        to_port     = 22
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "HTTP"
        protocol    = "TCP"
        from_port   = 80
        to_port     = 80
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "HTTPS"
        protocol    = "TCP"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}
