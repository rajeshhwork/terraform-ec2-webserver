
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "terraform-webserver-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = "vpc-0bb7de70641474c0a"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0e6cb4132897a3dd1"
  key_name                    = "IEDEVINFRA"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF2
#!/bin/bash
dnf update -y
dnf install nginx -y
systemctl enable nginx
systemctl start nginx

echo "<h1>Terraform EC2 Web Server</h1><h2>Hosted by Rajesh</h2>" > /usr/share/nginx/html/index.html
EOF2

  tags = {
    Name = "terraform-webserver"
  }
}

