provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

module "storage-bucket" {
  source   = "SweetOps/storage-bucket/google"
  name     = "reddit-app-storage"
  location = var.region
}

output storage-bucket_url {
  value = module.storage-bucket.url
}
