# main.tf
resource "aws_eip" "this" {
  domain = var.domain

  instance                  = var.instance_id
  network_interface         = var.network_interface_id
  associate_with_private_ip = var.associate_with_private_ip

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  lifecycle {
    # Prevent accidental deletion of EIPs
    prevent_destroy = false
  }
}
