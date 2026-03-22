resource "aws_instance" "my_ec2" {
  ami           = "ami-007dcf089b8078f1a"
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }

}
