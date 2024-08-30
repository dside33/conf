output "bastion_host_id" {
  description = "ID bastion-host"
  value       = yandex_compute_instance.bastion-host.id
}

output "private" {
  description = "ID private"
  value       = yandex_compute_instance.private.id
}

output "external_ip" {
  value = yandex_vpc_address.addr.external_ipv4_address.0.address
}