data "cloudinit_config" "debian" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "bootstrap-debian.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/config/bootstrap-debian.sh")
  }

  part {
    filename     = "bootstrap.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/config/cloud-config-debian.yaml")
  }
}
