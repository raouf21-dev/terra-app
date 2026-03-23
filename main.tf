resource "aws_launch_configuration" "example" {
  image_id        = "ami-007dcf089b8078f1a"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.terra_app_sg.id]

  user_data = <<-EOF
                  #!/bin/bash
                  set -eux
                  cd /home/ubuntu
                  echo "Hello, World!" > index.html
                  nohup python3 -m http.server ${var.server_port} > /var/log/http-server.log 2>&1 &
               EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {

  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  max_size = 10
  min_size = 2

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }

}

resource "aws_security_group" "terra_app_sg" {
  name = "terra_app_sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
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

# output "ec2_public_ip" {
#   value       = aws_instance.my_ec2.public_ip
#   description = "ec2 Public IP"
# }

