# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "this" {
  ami = local.selected_ami

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.005
    }
  }
  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    {"Name": var.instance_name},
    var.tags)

  instance_type = var.instance_type

  associate_public_ip_address = var.associate_public_ip_address

  user_data = data.cloudinit_config.debian.rendered

  key_name = var.create_key == true ? aws_key_pair.this.key_name : ""
  subnet_id = var.subnet_id

  iam_instance_profile        = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

}
