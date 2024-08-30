resource "yandex_vpc_security_group" "bastion_sg" {
  name        = var.sg_name
  description = "description for my security group"
  network_id  = var.network_id

  dynamic "ingress" {
    for_each = var.ssh_access_ips
    content {
      description  = ingress.value.name
      protocol     = "TCP"
      port         = 22
      v4_cidr_blocks = [ingress.value.ip]
    }
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all ICMP outbound traffic"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private_sg" {
  name      = "private-sg"
  network_id = var.network_id

  ingress {
    description    = "ssh from bastion"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.bastion_external_ip] #только для бастиона
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all ICMP outbound traffic"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

