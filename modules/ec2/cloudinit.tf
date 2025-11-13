data "cloudinit_config" "debian" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "bootstrap-debian.sh"
    content_type = "text/x-shellscript"
    content      = var.custom_bootstrap_script != "" ? file(var.custom_bootstrap_script) : file("${path.module}/config/bootstrap-debian.sh")
  }

  part {
    filename     = "bootstrap.yaml"
    content_type = "text/cloud-config"
    content      = var.custom_cloud_config != "" ? file(var.custom_cloud_config) : file("${path.module}/config/cloud-config-debian.yaml")
  }
}

data "cloudinit_config" "ubuntu" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "bootstrap-ubuntu.sh"
    content_type = "text/x-shellscript"
    content      = var.custom_bootstrap_script != "" ? file(var.custom_bootstrap_script) : file("${path.module}/config/bootstrap-ubuntu.sh")
  }

  part {
    filename     = "bootstrap.yaml"
    content_type = "text/cloud-config"
    content      = var.custom_cloud_config != "" ? file(var.custom_cloud_config) : file("${path.module}/config/cloud-config-ubuntu.yaml")
  }
}

data "cloudinit_config" "freebsd" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "bootstrap-freebsd.sh"
    content_type = "text/x-shellscript"
    content      = var.custom_bootstrap_script != "" ? file(var.custom_bootstrap_script) : file("${path.module}/config/bootstrap-freebsd.sh")
  }

  part {
    filename     = "bootstrap.yaml"
    content_type = "text/cloud-config"
    content      = var.custom_cloud_config != "" ? file(var.custom_cloud_config) : file("${path.module}/config/cloud-config-freebsd.yaml")
  }
}

data "cloudinit_config" "flatcar" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "bootstrap-flatcar.sh"
    content_type = "text/x-shellscript"
    content      = var.custom_bootstrap_script != "" ? file(var.custom_bootstrap_script) : file("${path.module}/config/bootstrap-flatcar.sh")
  }

  part {
    filename     = "bootstrap.yaml"
    content_type = "text/cloud-config"
    content      = var.custom_cloud_config != "" ? file(var.custom_cloud_config) : file("${path.module}/config/cloud-config-flatcar.yaml")
  }
}

locals {
  selected_cloudinit = var.os_family == "debian" ? data.cloudinit_config.debian.rendered : (var.os_family == "freebsd" ? data.cloudinit_config.freebsd.rendered : (var.os_family == "flatcar" ? data.cloudinit_config.flatcar.rendered : data.cloudinit_config.ubuntu.rendered))
}
