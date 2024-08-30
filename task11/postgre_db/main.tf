resource "yandex_mdb_postgresql_cluster" "db_cluster" {
  name        = var.cluster_name
  environment = var.environment

  network_id = var.network_id

  config {
    version = "15"

    resources {
      resource_preset_id = var.resource_preset_id
      disk_type_id       = var.disk_type_id
      disk_size          = var.disk_size
    }
  }

  host {
    zone      = var.zone
    subnet_id = var.subnet_id
  }
}

resource "yandex_mdb_postgresql_user" "user_admin" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = var.admin_user
  password   = var.admin_password
}


resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.user_admin.name
}


