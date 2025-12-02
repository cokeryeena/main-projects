provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
  tags = { Name = "vpn-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"
  availability_zone = var.az
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.1.2.0/24"
  availability_zone = var.az
}

resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "allow icmp for tests"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.onprem_cidr]
  }
  ingress {
    description = "ssh from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_ip]
  }
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
}

resource "aws_instance" "test_private" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags = { Name = "private-test" }
}

# Virtual Private Gateway (VGW)
resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.main.id
  amazon_side_asn = 64512
}

# Customer Gateway (fill onprem_public_ip)
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = var.onprem_public_ip
  type       = "ipsec.1"
  tags = { Name = "onprem-cgw" }
}

# VPN connection (static routes example)
resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = aws_customer_gateway.cgw.id
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = { Name = "onprem-vpn" }
}

resource "aws_vpn_connection_route" "route_to_onprem" {
  vpn_connection_id = aws_vpn_connection.vpn.id
  destination_cidr_block = var.onprem_cidr
}
