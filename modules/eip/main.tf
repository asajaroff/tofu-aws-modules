# main.tf
resource "aws_eip" "this" {
  domain   = "vpc"
}
