# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "this" {
  for_each                    = { for instance in var.instances_map : instance.name => instance }
  instance_type               = each.value.instance_type
  ami                         = local.selected_ami
  key_name                    = var.create_key == true ? aws_key_pair.this.key_name : ""
  subnet_id                   = var.subnet_id
  associate_public_ip_address = each.value.public
  user_data                   = data.cloudinit_config.debian.rendered
  iam_instance_profile        = aws_iam_instance_profile.this.name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  # Root block device configuration
  root_block_device {
    volume_type           = "gp3"                  # Options: "gp3", "gp2", "io1", "io2", "standard"
    volume_size           = each.value.volume_size # Size of the volume in GB
    delete_on_termination = true
  }

  # Spot instance configuration
  dynamic "instance_market_options" {
    for_each = var.spot_enabled ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price                      = 0.005
        instance_interruption_behavior = "stop"
      }
    }
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    { "Name" : each.value.name },
  var.tags)
}
