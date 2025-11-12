locals {
  selected_ami = var.os_family == "debian" ? data.aws_ami.debian.id : (var.os_family == "freebsd" ? data.aws_ami.freebsd.id : (var.os_family == "flatcar" ? data.aws_ami.flatcar.id : data.aws_ami.ubuntu.id))
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
    values = ["debian-13-${var.os_arch}-*"]
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

data "aws_ami" "flatcar" { # https://www.flatcar.org/docs/latest/installing/cloud/aws-ec2/
  most_recent = true
  filter {
    name   = "name"
    values = ["Flatcar-stable-*-hvm"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = [var.os_arch == "amd64" ? "x86_64" : "arm64"]
  }
  owners = ["075585003325"] # Official Flatcar Container Linux
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}
