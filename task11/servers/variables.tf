variable "public_zone" {
  description = "Зона, в которой будет создана публичная машина"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Путь к файлу с публичным SSH ключом"
  type        = string
}

variable "public_subnet_id" {
  description = "ID публичной подсети"
  type        = string
}

variable "private_zone" {
  description = "Приватная зона"
  type        = string
}

variable "private_subnet_id" {
  description = "Приватная подсеть"
  type        = string
}

variable "private_security_group_id" {
  description = "Приватная ГБ"
  type        = string
}

variable "bastion_security_group_id" {
  description = "Приватная ГБ"
  type        = string
}