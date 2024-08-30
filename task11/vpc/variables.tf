variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "public_subnet_name" {
  description = "The name of the public subnet"
  type        = string
}

variable "public_zone" {
  description = "The zone of the public subnet"
  type        = string
}

variable "public_cidr_block" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "private_zone" {
  description = "Zone of the private subnet"
  type        = string
}

variable "private_cidr_block" {
  description = "CIDR block of the private subnet"
  type        = string
}