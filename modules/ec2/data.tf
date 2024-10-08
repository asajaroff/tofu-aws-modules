locals {
  selected_ami = var.os_family == "debian" ? data.aws_ami.debian.id : (var.os_family == "freebsd" ? data.aws_ami.freebsd.id : data.aws_ami.ubuntu.id)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-${var.os_arch}-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_ami" "debian" {
  most_recent = true
  filter {
    name   = "name"
    values = ["debian-12-${var.os_arch}-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["136693071363"] # https://wiki.debian.org/Cloud/AmazonEC2Image/
}

data "aws_ami" "freebsd" { # https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#Images:visibility=public-images;imageName=:FreeBSD%2014.1-STABLE-;v=3;$case=tags:false%5C,client:false;$regex=tags:false%5C,client:false
  most_recent = true
  filter {
    name   = "name"
    values = ["FreeBSD 14.1-STABLE-${var.os_arch}-* base UFS"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["782442783595"] # https://wiki.debian.org/Cloud/AmazonEC2Image/
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}
