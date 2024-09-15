# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "this" {
  ami = data.aws_ami.freebsd.id

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.005
    }
  }

  instance_type = "t3.micro"

  associate_public_ip_address = true

  key_name = aws_key_pair.this.key_name

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}
