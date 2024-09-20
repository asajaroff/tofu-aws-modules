data "cloudinit_config" "foobar" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "bootstrap.sh"
    content_type = "text/x-shellscript"
    content = file("${path.module}/config/bootstrap.sh")
  }

  part {
    filename     = "bootstrap.yaml"
    content_type = "text/cloud-config"
    content = file("${path.module}/config/cloud-config.yaml")
  }
}
