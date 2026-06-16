resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  tags = {
    Name = "Web Server"
  }

  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.default.key_name
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file(var.key_name)
}


resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
}
