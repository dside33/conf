terraform {
  required_providers {
    opentofu = {
      source  = "opentofu/yandex"
      version = "0.45.0"
    }
  }
}

provider "yandex" {
  token     = ""
  cloud_id  = ""
  folder_id = ""
  zone      = "ru-central1-a"
}

module "vpc" {
  source              = "./vpc"
  network_name        = "terr-vpc"
  public_subnet_name  = "terr-public-subnet"
  public_zone         = "ru-central1-a"
  public_cidr_block   = "10.0.1.0/24"
  private_subnet_name = "terr-private-subnet"
  private_zone        = "ru-central1-b"
  private_cidr_block  = "10.0.2.0/24"
}

module "security_group" {
  source              = "./SG"
  sg_name             = "bastion-sg"
  network_id          = module.vpc.vpc_network_id
  bastion_external_ip = "10.0.1.18/32"
  ssh_access_ips = {
    "allow_ssh_from_home" = {
      name = "home ssh"
      ip   = "81.27.58.23/32"
    }
  }
}

module "servers" {
  source = "./servers"

  public_zone               = "ru-central1-a"
  ssh_public_key_path       = "L:/Dev-opppps/11-terr/public.txt"
  public_subnet_id          = module.vpc.public_subnet_id
  bastion_security_group_id = module.security_group.bastion_security_group_id

  private_zone              = "ru-central1-b"
  private_subnet_id         = module.vpc.private_subnet_id
  private_security_group_id = module.security_group.private_security_group_id
}

module "postgresql" {
  source            = "./postgre_db"
  cluster_name      = "terr-postgre-cluster"
  environment       = "PRODUCTION"
  network_id        = module.vpc.vpc_network_id
  resource_preset_id = "s2.micro"
  disk_type_id      = "network-hdd"
  disk_size         = 10
  zone              = "ru-central1-a"
  subnet_id         = module.vpc.public_subnet_id
  admin_user        = "adminalldb"
  admin_password    = "adminadmin"
  db_name           = "terr-db"
}