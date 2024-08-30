variable "cluster_name" {
  description = "Имя кластера"
  type        = string
}

variable "environment" {
  description = "'PRODUCTION' или 'PRESTABLE'"
  type        = string
  default     = "PRODUCTION"
}

variable "network_id" {
  description = "id сети"
  type        = string
}

variable "resource_preset_id" {
  description = "(s2.micro, s2.small)"
  type        = string
  default     = "s2.micro"
}

variable "disk_size" {
  type        = number
#   default     = 10737418240 # 10GB
}

variable "disk_type_id" {
  description = "network-ssd или network-hdd"
  type        = string
  default     = "network-hdd"
}

variable "zone" {
  type        = string
}

variable "subnet_id" {
  type        = string
}

variable "admin_user" {
  type        = string
}

variable "admin_password" {
  type        = string
}

variable "db_name" {
  type        = string
}
