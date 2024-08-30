resource "yandex_vpc_address" "addr" {
  name = "exampleAddress"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

resource "yandex_compute_instance" "bastion-host" {
  name        = "bastion-host"
  platform_id = "standard-v1"
  zone        = var.public_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87j6d92jlrbjqbl32q"
    }
  }

  network_interface {
    subnet_id = var.public_subnet_id
    nat       = true

    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address.0.address
    security_group_ids = [var.bastion_security_group_id]
  } 

  metadata = {
    ssh-keys = "ubuntu:${file("public.txt")}"
    user-data = "${file("L:/Dev-opppps/11-terr/meta.txt")}"
  }   
}


resource "yandex_compute_instance" "private" {
  name        = "private"
  platform_id = "standard-v1"
  zone        = var.private_zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd87j6d92jlrbjqbl32q"
    }
  }

  network_interface {
    subnet_id = var.private_subnet_id

    security_group_ids = [var.private_security_group_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("public.txt")}"
    user-data = "${file("L:/Dev-opppps/11-terr/meta.txt")}"
  }
}
