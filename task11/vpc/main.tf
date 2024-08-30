resource "yandex_vpc_network" "vpc_network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "public_subnet" {
  name           = var.public_subnet_name
  v4_cidr_blocks = [var.public_cidr_block]
  zone           = var.public_zone
  network_id     = "${yandex_vpc_network.vpc_network.id}"

  # route_table_id = yandex_vpc_route_table.route_table1.id
}

resource "yandex_vpc_subnet" "private_subnet" {
  name           = var.private_subnet_name
  zone           = var.private_zone
  network_id     = "${yandex_vpc_network.vpc_network.id}"
  v4_cidr_blocks = [var.private_cidr_block]

  route_table_id = yandex_vpc_route_table.route_table1.id
}

resource "yandex_vpc_gateway" "egress_gateway" {
  name = "egress-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route_table1" {
  name        = "route-table1"
  network_id  = yandex_vpc_network.vpc_network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.egress_gateway.id #весь трафик через этот шлюз
  }
}