terraform {
  required_version = "~>0.12"
}

provider "google" {
  version = "~>2.5.0"

  project = var.project
  region  = var.region
}

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  zone            = var.zone
  app_disk_image  = var.app_disk_image
  instance_count = var.instance_count
  db_url = module.db.db_internal_ip
  private_key_path = var.private_key_path
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = var.allowed_ips
}
