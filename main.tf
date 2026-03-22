resource "aws_instance" "my_ec2" {
  ami           = "ami-007dcf089b8078f1a"
  instance_type = "t2.micro"

  user_data = <<-EOF
                #!/bin/bash
                set -e
                apt update -y
                apt install -y nginx
                echo "Hello, World!" > /var/www/html/index.html
                systemctl enable nginx
                systemctl start nginx
            EOF
  tags = {
    Name = "MyEC2Instance"
  }
  vpc_security_group_ids = [aws_security_group.terra_app_sg.id]
}

resource "aws_security_group" "terra_app_sg" {
  name = "terra_app_sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  tags = {
    Name = "terra_app_sg"
  }
}
