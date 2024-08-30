output "db_cluster_id" {
  description = "id кластера"
  value       = yandex_mdb_postgresql_cluster.db_cluster.id
}
