# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
resource "tls_private_key" "this" {
  count     = var.create_key == true ? 1 : 0
  algorithm = "ED25519"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "this" {
  key_name   = "Autogenerated key"
  public_key = tls_private_key.this[0].public_key_openssh
}