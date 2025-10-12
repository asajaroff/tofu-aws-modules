# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_ec2"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {

  provisioner "local-exec" {
    command = "dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com"
  }

  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = var.allow_ssh_ip == "" ? "123.123.123.123/32" : var.allow_ssh_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
#   security_group_id = aws_security_group.allow_ssh.id
#   cidr_ipv6         = data.aws_vpc.selected.ipv6_cidr_block
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
#   security_group_id = aws_security_group.allow_ssh.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }


# Places to get the IP address from
# dig +short txt ch whoami.cloudflare @1.0.0.1
# dig +short myip.opendns.com @resolver1.opendns.com
# dig TXT +short o-o.myaddr.l.google.com @ns1.google.com
