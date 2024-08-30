variable "sg_name" {
  description = "sg name"
  type        = string
}

variable "network_id" {
  description = "network id"
  type        = string
}

variable "ssh_access_ips" {
  description = "map ip"
  type = map(object({
    name = string
    ip   = string
  }))
}

variable "bastion_external_ip" {
  description = "bastion_external_ip"
  type        = string
}
